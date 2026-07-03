#include <array>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <random>
#include <vector>
static constexpr int dirs[6][3]={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}};
struct Record{int n;double speed,radial,axisness;};
int main(){std::mt19937_64 rng(2026070406);std::uniform_real_distribution<double>u(0,1);const double step=.025,boundary=20,encounter=.95;const int samples=40000;
 std::cout<<"rule size_bin exit_geometry count mean_n mean_speed mean_radial sd_speed\n"<<std::fixed<<std::setprecision(6);
 for(bool perpendicular:{true,false}){std::vector<Record>records;records.reserve(samples);
  for(int sample=0;sample<samples;++sample){std::array<int,6>c{};c[rng()%6]=1;int n=1;double p[3]{};
   for(int tick=0;tick<250000;++tick){int pick=rng()%n,active=0,sum=c[0];while(pick>=sum)sum+=c[++active];for(int a=0;a<3;++a)p[a]+=step*dirs[active][a];double pr=std::sqrt(p[0]*p[0]+p[1]*p[1]+p[2]*p[2]);
    if(pr>=boundary){double net[3]={(double)(c[0]-c[1])/n,(double)(c[2]-c[3])/n,(double)(c[4]-c[5])/n};double speed=std::sqrt(net[0]*net[0]+net[1]*net[1]+net[2]*net[2]);double radial=(net[0]*p[0]+net[1]*p[1]+net[2]*p[2])/pr;double axisness=std::max({std::abs(p[0]),std::abs(p[1]),std::abs(p[2])})/pr;records.push_back({n,speed,radial,axisness});break;}
    if(u(rng)>=encounter)continue;double source[3],sr2;do{sr2=0;for(double&x:source){x=(2*u(rng)-1)*boundary;sr2+=x*x;}}while(sr2>boundary*boundary);double delta[3]={p[0]-source[0],p[1]-source[1],p[2]-source[2]};int axis=0;if(std::abs(delta[1])>std::abs(delta[axis]))axis=1;if(std::abs(delta[2])>std::abs(delta[axis]))axis=2;int incoming=2*axis+(delta[axis]<0);if(perpendicular&&axis==active/2)continue;if(u(rng)<.5){++c[incoming];++n;}else if(n>1){--c[active];--n;}
   }}
  const int edges[]={20,50,100,150,250,1000000};for(int b=0;b<5;++b)for(int geometry=0;geometry<3;++geometry){double sn=0,sv=0,sr=0,sv2=0;int count=0;for(auto&r:records)if(r.n>=edges[b]&&r.n<edges[b+1]){bool include=geometry==0||(geometry==1&&r.axisness>.9)||(geometry==2&&r.axisness<.7);if(include){sn+=r.n;sv+=r.speed;sr+=r.radial;sv2+=r.speed*r.speed;++count;}}if(count<20)continue;double mean=sv/count;std::cout<<(perpendicular?"perpendicular":"all")<<' '<<edges[b]<<'-'<<edges[b+1]-1<<' '<<(geometry==0?"all":geometry==1?"axis-like":"diagonal-like")<<' '<<count<<' '<<sn/count<<' '<<mean<<' '<<sr/count<<' '<<std::sqrt(sv2/count-mean*mean)<<'\n';}
 }
}
