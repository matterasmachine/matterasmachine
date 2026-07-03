#include <array>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>

static constexpr int directions[6][3]={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}};

struct Observation { int length, ticks, endpoint; };

double correlation_squared(const std::vector<double>& x,const std::vector<double>& y){
  double mx=0,my=0; for(double v:x)mx+=v; for(double v:y)my+=v;
  mx/=x.size();my/=y.size(); double covariance=0,vx=0,vy=0;
  for(size_t i=0;i<x.size();++i){covariance+=(x[i]-mx)*(y[i]-my);vx+=(x[i]-mx)*(x[i]-mx);vy+=(y[i]-my)*(y[i]-my);}
  return covariance*covariance/(vx*vy);
}

int main(){
  std::mt19937_64 rng(2026070322); std::uniform_real_distribution<double> unit(0,1);
  const double radius=3,step=.025; const int samples=120000;
  std::cout<<std::fixed<<std::setprecision(6);
  std::cout<<"lambda mean_L mean_ticks L_vs_ticks_R2 exp_survival_R2 q_escape cv_q q_path r_path r_endpoint range_start range_end\n";
  for(double lambda:{.1,.3,.5,1.,2.}){
    std::poisson_distribution<int> encounters(lambda); std::vector<Observation> observations; observations.reserve(samples);
    int maximum_length=0;
    for(int sample=0;sample<samples;++sample){
      std::array<int,6> counts{};counts[rng()%6]=1;int n=1,length=0;double position[3]{};
      for(int tick=1;tick<250000;++tick){
        int pick=rng()%n,active=0,cumulative=counts[0];while(pick>=cumulative)cumulative+=counts[++active];
        for(int axis=0;axis<3;++axis)position[axis]+=step*directions[active][axis];
        double r2=position[0]*position[0]+position[1]*position[1]+position[2]*position[2];
        if(r2>=radius*radius){observations.push_back({length,tick,n});maximum_length=std::max(maximum_length,length);break;}
        for(int event=0,count=encounters(rng);event<count;++event){
          double source[3],sr2;do{sr2=0;for(double& coordinate:source){coordinate=(2*unit(rng)-1)*radius;sr2+=coordinate*coordinate;}}while(sr2>radius*radius);
          double delta[3]={position[0]-source[0],position[1]-source[1],position[2]-source[2]};int axis=0;
          if(std::abs(delta[1])>std::abs(delta[axis]))axis=1;if(std::abs(delta[2])>std::abs(delta[axis]))axis=2;
          int incoming=2*axis+(delta[axis]<0);if(axis==active/2)continue;
          if(unit(rng)<.5){++counts[incoming];++n;++length;}
          else if(n>1){--counts[active];--n;++length;}
        }
      }
    }
    std::vector<int> survival(maximum_length+2,0);double mean_length=0,mean_ticks=0,mean_endpoint=0;
    std::vector<double> lengths,ticks;
    for(const auto& o:observations){mean_length+=o.length;mean_ticks+=o.ticks;mean_endpoint+=o.endpoint;lengths.push_back(o.length);ticks.push_back(o.ticks);for(int l=0;l<=o.length;++l)++survival[l];}
    mean_length/=observations.size();mean_ticks/=observations.size();mean_endpoint/=observations.size();
    // Use the central survival range: enough distance from L=0 and at least 500 survivors.
    int start=std::max(2,(int)std::floor(mean_length*.25)),end=start;
    while(end+1<(int)survival.size()&&survival[end+1]>=500)++end;
    std::vector<double> ls,log_survival,ratios;
    for(int l=start;l<=end;++l){ls.push_back(l);log_survival.push_back(std::log((double)survival[l]/samples));if(l<end)ratios.push_back((double)survival[l+1]/survival[l]);}
    double mean_q=0;for(double q:ratios)mean_q+=q;mean_q/=ratios.size();double variance_q=0;for(double q:ratios)variance_q+=(q-mean_q)*(q-mean_q);variance_q/=ratios.size();
    const double q_path=mean_q/2;
    const double r_path=(1-std::sqrt(1-4*q_path*q_path))/(2*q_path);
    const double r_endpoint=(mean_endpoint-1)/mean_endpoint;
    std::cout<<lambda<<' '<<mean_length<<' '<<mean_ticks<<' '<<correlation_squared(ticks,lengths)<<' '
             <<correlation_squared(ls,log_survival)<<' '<<mean_q<<' '<<std::sqrt(variance_q)/mean_q<<' '
             <<q_path<<' '<<r_path<<' '<<r_endpoint<<' '<<start<<' '<<end<<'\n';
  }
}
