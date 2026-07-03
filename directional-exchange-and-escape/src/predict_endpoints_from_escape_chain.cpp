#include <array>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>

static constexpr int directions[6][3]={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}};
struct Counts { std::vector<std::vector<unsigned long long>> next; std::vector<unsigned long long> escape,total; };

int trajectory(double radius,double lambda,std::mt19937_64& rng,Counts* learned){
  std::uniform_real_distribution<double>unit(0,1);std::poisson_distribution<int>encounters(lambda);
  std::array<int,6>counts{};counts[rng()%6]=1;int n=1;double position[3]{};
  auto ensure=[&](int size){if(size<(int)(learned?learned->total.size():0))return;if(!learned)return;int old=learned->total.size(),target=std::max(size+1,old*2+2);learned->total.resize(target);learned->escape.resize(target);learned->next.resize(target);for(auto&row:learned->next)row.resize(target);};
  for(int tick=0;tick<250000;++tick){
    int before=n;if(learned)ensure(before);
    int pick=rng()%n,active=0,cumulative=counts[0];while(pick>=cumulative)cumulative+=counts[++active];
    for(int axis=0;axis<3;++axis)position[axis]+=.025*directions[active][axis];
    double r2=position[0]*position[0]+position[1]*position[1]+position[2]*position[2];
    if(r2>=radius*radius){if(learned){++learned->total[before];++learned->escape[before];}return n;}
    for(int event=0,count=encounters(rng);event<count;++event){
      double source[3],sr2;do{sr2=0;for(double&coordinate:source){coordinate=(2*unit(rng)-1)*radius;sr2+=coordinate*coordinate;}}while(sr2>radius*radius);
      double delta[3]={position[0]-source[0],position[1]-source[1],position[2]-source[2]};int axis=0;
      if(std::abs(delta[1])>std::abs(delta[axis]))axis=1;if(std::abs(delta[2])>std::abs(delta[axis]))axis=2;
      int incoming=2*axis+(delta[axis]<0);if(axis==active/2)continue;
      if(unit(rng)<.5){++counts[incoming];++n;}else if(n>1){--counts[active];--n;}
    }
    if(learned){ensure(n);++learned->total[before];++learned->next[before][n];}
  }
  return n;
}

double tv_distance(const std::vector<double>&a,const std::vector<double>&b){double sum=0;size_t m=std::max(a.size(),b.size());for(size_t i=1;i<m;++i)sum+=std::abs((i<a.size()?a[i]:0)-(i<b.size()?b[i]:0));return .5*sum;}

int main(){
  std::mt19937_64 rng(2026070402);std::cout<<"radius lambda r_test geometric_TV chain_TV absorbed_mass trained_states\n"<<std::fixed<<std::setprecision(6);
  for(auto parameters:{std::array<double,2>{1.,.1},std::array<double,2>{1.,.3},std::array<double,2>{3.,.1},std::array<double,2>{3.,.3},std::array<double,2>{3.,1.},std::array<double,2>{5.,1.}}){
    double radius=parameters[0],lambda=parameters[1];Counts learned;
    for(int i=0;i<80000;++i)trajectory(radius,lambda,rng,&learned);
    int test_samples=80000;std::vector<double>test(2,0);
    for(int i=0;i<test_samples;++i){int n=trajectory(radius,lambda,rng,nullptr);if(n>=(int)test.size())test.resize(n+1);test[n]+=1.0/test_samples;}
    double mean=0;for(size_t n=1;n<test.size();++n)mean+=n*test[n];double r=(mean-1)/mean;
    std::vector<double>geometric(test.size()+200,0);for(size_t n=1;n<geometric.size();++n)geometric[n]=(1-r)*std::pow(r,(int)n-1);
    size_t states=learned.total.size();std::vector<double>mass(states,0),next(states,0),predicted(states,0);mass[1]=1;
    for(int iteration=0;iteration<200000;++iteration){std::fill(next.begin(),next.end(),0);double live=0;
      for(size_t n=1;n<states;++n)if(mass[n]>0&&learned.total[n]>0){double denominator=learned.total[n];predicted[n]+=mass[n]*learned.escape[n]/denominator;for(size_t j=1;j<states;++j)if(learned.next[n][j])next[j]+=mass[n]*learned.next[n][j]/denominator;}
      mass.swap(next);for(double value:mass)live+=value;if(live<1e-12)break;
    }
    double absorbed=0;for(double value:predicted)absorbed+=value;int trained_states=0;for(size_t n=1;n<states;++n)if(learned.total[n])++trained_states;
    std::cout<<radius<<' '<<lambda<<' '<<r<<' '<<tv_distance(test,geometric)<<' '<<tv_distance(test,predicted)<<' '<<absorbed<<' '<<trained_states<<'\n';
  }
}
