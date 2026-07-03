#include <cmath>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>

double geometric_tv(const std::vector<int>& particles){
  long long excess=0;int maximum=0;for(int n:particles){excess+=n-1;maximum=std::max(maximum,n-1);}
  const double mean=(double)excess/particles.size(),r=mean/(1+mean);
  std::vector<int>histogram(maximum+1);for(int n:particles)++histogram[n-1];
  double difference=0;for(int q=0;q<=maximum;++q)difference+=std::abs((double)histogram[q]/particles.size()-(1-r)*std::pow(r,q));
  difference+=std::pow(r,maximum+1);return .5*difference;
}

int main(){
  std::mt19937_64 rng(2026070403);
  const int per_bath=1000,total_particles=2*per_bath;
  std::vector<int>n(total_particles,1);
  // Same conserved total matter, initially distributed very unevenly.
  for(int q=0;q<8000;++q)++n[rng()%per_bath];
  for(int q=0;q<1000;++q)++n[per_bath+rng()%per_bath];
  long long net_A_to_B=0,attempted_cross=0;
  std::uniform_int_distribution<int>pick(0,total_particles-1);
  std::cout<<"step mean_excess_A mean_excess_B net_A_to_B_per_cross_attempt\n"<<std::fixed<<std::setprecision(6);
  const long long steps=50000000,report_every=5000000;
  for(long long step=1;step<=steps;++step){
    int donor=pick(rng),receiver=pick(rng);while(receiver==donor)receiver=pick(rng);
    bool cross=(donor<per_bath)!=(receiver<per_bath);if(cross)++attempted_cross;
    if(n[donor]>1){--n[donor];++n[receiver];if(cross)net_A_to_B+=(donor<per_bath?1:-1);}
    if(step%report_every==0){
      long long qa=0,qb=0;for(int i=0;i<per_bath;++i)qa+=n[i]-1;for(int i=per_bath;i<total_particles;++i)qb+=n[i]-1;
      std::cout<<step<<' '<<(double)qa/per_bath<<' '<<(double)qb/per_bath<<' '<<(double)net_A_to_B/attempted_cross<<'\n';
      net_A_to_B=attempted_cross=0;
    }
  }
  long long total_excess=0;for(int value:n)total_excess+=value-1;
  const double mean_excess=(double)total_excess/total_particles;
  const double r=mean_excess/(1+mean_excess);
  const double beta_epsilon=std::log(1+1/mean_excess);
  std::vector<int>a(n.begin(),n.begin()+per_bath),b(n.begin()+per_bath,n.end());
  std::cerr<<"equilibrium mean excess="<<mean_excess<<" r="<<r<<" beta*epsilon="<<beta_epsilon
           <<" TV_A="<<geometric_tv(a)<<" TV_B="<<geometric_tv(b)<<'\n';
}
