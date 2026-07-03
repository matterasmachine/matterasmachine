#include <array>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>

static constexpr int directions[6][3]={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}};

struct Metrics { double mean,r,tv,tail_tv,kl,max_error; };

Metrics compare_geometric(const std::vector<int>& histogram,int samples){
  double mean=0;for(size_t n=1;n<histogram.size();++n)mean+=n*(double)histogram[n]/samples;
  const double r=(mean-1)/mean;
  double tv=0,tail_tv=0,kl=0,max_error=0;
  const int tail_start=std::max(2,(int)std::floor(mean));
  for(size_t n=1;n<histogram.size();++n){
    const double observed=(double)histogram[n]/samples;
    const double expected=(1-r)*std::pow(r,(int)n-1);
    const double error=std::abs(observed-expected);
    tv+=error; if((int)n>=tail_start)tail_tv+=error; max_error=std::max(max_error,error);
    if(observed>0&&expected>0)kl+=observed*std::log(observed/expected);
  }
  // Include geometric probability beyond the largest observed endpoint.
  const double omitted=std::pow(r,(int)histogram.size()-1);
  tv+=omitted;tail_tv+=omitted;
  return {mean,r,.5*tv,.5*tail_tv,kl,max_error};
}

int main(){
  std::mt19937_64 rng(2026070401);std::uniform_real_distribution<double>unit(0,1);
  const double step=.025;const int samples=60000;
  std::cout<<"radius lambda mean_size fitted_r TV tail_TV KL max_bin_error\n"<<std::fixed<<std::setprecision(6);
  for(double radius:{.5,1.,2.,3.,5.})for(double lambda:{.03,.1,.3,1.,3.,10.}){
    std::poisson_distribution<int>encounters(lambda);std::vector<int>histogram(2,0);
    for(int sample=0;sample<samples;++sample){
      std::array<int,6>counts{};counts[rng()%6]=1;int n=1;double position[3]{};
      for(int tick=1;tick<250000;++tick){
        int pick=rng()%n,active=0,cumulative=counts[0];while(pick>=cumulative)cumulative+=counts[++active];
        for(int axis=0;axis<3;++axis)position[axis]+=step*directions[active][axis];
        double radius_squared=position[0]*position[0]+position[1]*position[1]+position[2]*position[2];
        if(radius_squared>=radius*radius){if(n>=(int)histogram.size())histogram.resize(n+1);++histogram[n];break;}
        for(int event=0,count=encounters(rng);event<count;++event){
          double source[3],source_r2;do{source_r2=0;for(double&coordinate:source){coordinate=(2*unit(rng)-1)*radius;source_r2+=coordinate*coordinate;}}while(source_r2>radius*radius);
          double delta[3]={position[0]-source[0],position[1]-source[1],position[2]-source[2]};int axis=0;
          if(std::abs(delta[1])>std::abs(delta[axis]))axis=1;if(std::abs(delta[2])>std::abs(delta[axis]))axis=2;
          int incoming=2*axis+(delta[axis]<0);if(axis==active/2)continue;
          if(unit(rng)<.5){++counts[incoming];++n;}else if(n>1){--counts[active];--n;}
        }
      }
    }
    Metrics m=compare_geometric(histogram,samples);
    std::cout<<radius<<' '<<lambda<<' '<<m.mean<<' '<<m.r<<' '<<m.tv<<' '<<m.tail_tv<<' '<<m.kl<<' '<<m.max_error<<'\n';
  }
}
