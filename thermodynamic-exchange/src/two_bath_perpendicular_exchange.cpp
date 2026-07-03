#include <array>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>

struct Particle { std::array<int,6> count{}; int size=1; };

int active_instruction(const Particle& particle,std::mt19937_64& rng){
  int pick=rng()%particle.size,direction=0,cumulative=particle.count[0];
  while(pick>=cumulative)cumulative+=particle.count[++direction];
  return direction;
}

double geometric_tv(const std::vector<Particle>& particles,int begin,int end){
  double mean=0;int maximum=1;for(int i=begin;i<end;++i){mean+=particles[i].size;maximum=std::max(maximum,particles[i].size);}
  mean/=(end-begin);double r=(mean-1)/mean;std::vector<int>histogram(maximum+1);
  for(int i=begin;i<end;++i)++histogram[particles[i].size];double difference=0;
  for(int n=1;n<=maximum;++n)difference+=std::abs((double)histogram[n]/(end-begin)-(1-r)*std::pow(r,n-1));
  difference+=std::pow(r,maximum);return .5*difference;
}

int main(int argc,char**argv){
  const bool require_perpendicular=argc<2||std::string(argv[1])!="all";
  std::mt19937_64 rng(2026070404);std::uniform_real_distribution<double>unit(0,1);
  const int per_bath=2000,total=2*per_bath;std::vector<Particle>particles(total);
  for(auto&particle:particles)particle.count[rng()%6]=1;
  // Initially hot A (8 excess instructions/particle), cold B (1 excess).
  for(int q=0;q<8*per_bath;++q){auto&p=particles[rng()%per_bath];++p.count[rng()%6];++p.size;}
  for(int q=0;q<1*per_bath;++q){auto&p=particles[per_bath+rng()%per_bath];++p.count[rng()%6];++p.size;}
  long long cross_attempts=0,cross_transfers=0,net_A_to_B=0,perpendicular=0;
  const long long events=200000000,report_every=20000000;
  std::cout<<"rule "<<(require_perpendicular?"perpendicular":"all-directions")<<'\n';
  std::cout<<"event mean_excess_A mean_excess_B net_A_to_B_per_cross transfer_per_cross perpendicular_fraction\n"<<std::fixed<<std::setprecision(7);
  for(long long event=1;event<=events;++event){
    int first,second;bool cross=unit(rng)<.2;
    if(cross){first=rng()%per_bath;second=per_bath+rng()%per_bath;++cross_attempts;}
    else if(unit(rng)<.5){first=rng()%per_bath;do second=rng()%per_bath;while(second==first);}
    else{first=per_bath+rng()%per_bath;do second=per_bath+rng()%per_bath;while(second==first);}
    int d1=active_instruction(particles[first],rng),d2=active_instruction(particles[second],rng);
    const bool is_perpendicular=d1/2!=d2/2;if(is_perpendicular)++perpendicular;
    if(!require_perpendicular||is_perpendicular){
      bool first_donates=unit(rng)<.5;int donor=first_donates?first:second,receiver=first_donates?second:first,direction=first_donates?d1:d2;
      if(particles[donor].size>1){--particles[donor].count[direction];--particles[donor].size;++particles[receiver].count[direction];++particles[receiver].size;
        if(cross){++cross_transfers;net_A_to_B+=(donor<per_bath?1:-1);}
      }
    }
    if(event%report_every==0){
      long long qa=0,qb=0;for(int i=0;i<per_bath;++i)qa+=particles[i].size-1;for(int i=per_bath;i<total;++i)qb+=particles[i].size-1;
      std::cout<<event<<' '<<(double)qa/per_bath<<' '<<(double)qb/per_bath<<' '<<(double)net_A_to_B/cross_attempts<<' '
               <<(double)cross_transfers/cross_attempts<<' '<<(double)perpendicular/report_every<<'\n';
      cross_attempts=cross_transfers=net_A_to_B=perpendicular=0;
    }
  }
  long long qa=0,qb=0;for(int i=0;i<per_bath;++i)qa+=particles[i].size-1;for(int i=per_bath;i<total;++i)qb+=particles[i].size-1;
  double ma=(double)qa/per_bath,mb=(double)qb/per_bath;
  std::cerr<<"final A="<<ma<<" B="<<mb<<" rA="<<ma/(1+ma)<<" rB="<<mb/(1+mb)
           <<" TV_A="<<geometric_tv(particles,0,per_bath)<<" TV_B="<<geometric_tv(particles,per_bath,total)<<'\n';
}
