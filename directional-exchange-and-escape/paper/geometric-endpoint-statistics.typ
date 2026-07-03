#set page(
  paper: "a4",
  margin: (top: 21mm, bottom: 22mm, left: 24mm, right: 24mm),
  numbering: "1",
  number-align: center + bottom,
)
#set text(font: "New Computer Modern", size: 10pt, lang: "en")
#set par(justify: true, leading: 0.58em)
#set heading(numbering: "1.")
#show heading.where(level: 1): it => block(above: 1.2em, below: 0.58em)[
  #set text(size: 13.2pt, weight: "semibold", fill: rgb("173f68"))
  #it
]
#show heading.where(level: 2): it => block(above: 0.95em, below: 0.42em)[
  #set text(size: 11.3pt, weight: "semibold", fill: rgb("173f68"))
  #it
]
#show math.equation.where(block: true): set block(above: 0.72em, below: 0.72em)
#set list(indent: 1.1em, body-indent: 0.55em)
#set table(stroke: rgb("c8d2df"), inset: 4.5pt)

#let note(body) = block(
  fill: rgb("f2f6fa"),
  stroke: (left: 2pt + rgb("2f7f96")),
  inset: (left: 10pt, right: 8pt, top: 7pt, bottom: 7pt),
  radius: 2pt,
  width: 100%,
  body,
)

#align(center)[
  #v(7mm)
  #text(size: 17pt, weight: "bold", fill: rgb("15263b"))[
    Geometric Endpoint Statistics from Directional #linebreak()
    One-Quantum Exchange and Spatial Escape
  ]
  #v(3mm)
  #text(size: 11.5pt, weight: "medium", fill: rgb("173f68"))[
    Exact benchmark, spherical realization, and coarse-grained prediction
  ]
  #v(7mm)
  #text(size: 10.5pt)[
    #link("https://x.com/matterasmachine")[Matter-as-machine]
  ]
]

#v(6mm)
#align(center)[#text(weight: "semibold", size: 11.5pt)[Abstract]]
#v(2mm)

This note studies an open stochastic formation process for particles represented
by nonempty lists of six directional instructions. At each motion tick one list
entry is executed. While the particle remains inside a spherical source region,
an incoming instruction may interact with the active entry; compatible
interactions change list length by one, and formation ends when the particle
crosses the boundary. No geometric endpoint law and no history weight are
inserted into this spatial simulation. As an exact benchmark, a coarse-grained
model with equal gain and loss rates and an independent constant escape rate is
proved to assign every surviving history a weight proportional to $q^L$, with
$0<q<1/2$, and therefore to produce an exact shifted geometric endpoint law.
The spatial process does not satisfy the benchmark assumptions: escape depends
on position, direction, composition, and elapsed history. Nevertheless, a sweep
of $30$ parameter regimes and $1.8$ million trajectories gives total-variation
distances between empirical endpoints and best-fit geometric laws from $0.005$
to $0.112$. A size-resolved absorbing Markov chain, estimated on independent
training trajectories, predicts held-out endpoint distributions with
total-variation error from $0.0027$ to $0.0152$ in six tested regimes. Escape
history survival is approximately exponential over a central range, but a
single mean escape parameter underpredicts the observed geometric ratio. The
result is therefore an approximate dynamical realization of geometric endpoint
statistics, not an exact derivation for the full directional model. Temperature,
the Planck spectrum, cosmological loss, and a universal speed are outside the
claim.

= Question and relation to preceding work

A preceding combinatorial note [1] proves that if every nonnegative one-quantum
gain/loss history $h$ of length $L(h)$ has weight $q^(L(h))$, where
$0<q<1/2$, then its endpoint $m>=0$ is geometric:

$ P(m)=(1-r)r^m, quad
  r=(1-sqrt(1-4q^2))/(2q). $

That theorem is exact, but $q^L$ is an ensemble definition rather than a
physical mechanism. The present question is:

#note[
Can motion, directional one-quantum exchange, and escape from a finite source
region generate approximately geometric endpoint sizes without manually
assigning $q^L$ to complete histories?
]

The answer is separated into two levels. Section 2 gives an exact
constant-hazard benchmark that does generate $q^L$. Sections 3-8 test a richer
spatial process whose escape hazard is neither independent nor constant. The
benchmark explains what would be sufficient; the simulation measures how close
the spatial dynamics comes to that idealization.

This paper concerns an open formation process. It is distinct from the closed
reversible-exchange ensemble of a companion thermodynamic note [2]. In the
closed model energy is conserved and exchange continues to equilibrium. Here a
single candidate is observed when it leaves an interaction region, so escape
freezes a transient endpoint.

= Exact benchmark: symmetric gain/loss with competing escape

== State and rates

Let the physical list size be $n>=1$ and define excess occupancy

$ m=n-1>=0. $

At each interior state, let gain and loss occur at equal continuous-time rate
$lambda>0$, while successful escape occurs independently at rate $mu>0$.
A loss that would take $m$ below zero removes the candidate from the surviving
ensemble. Thus every successfully observed trajectory is a nonnegative path.

Three exponential clocks compete. Conditional on the identity of the next
effective event, the probability of a specified gain or specified loss is

$ q=lambda/(2lambda+mu), $

and the probability of escape is

$ p_"esc"=mu/(2lambda+mu). $

Since $mu>0$,

$ 0<q<1/2. $

== Complete-history weight

Consider a particular allowed history $h$ containing $L$ gain/loss events and
then escape. Independence and the memoryless property give

$ P(h " followed by escape")=p_"esc" q^L. $

The escape prefactor is common to all successfully completed histories.
Conditioning on successful escape therefore gives relative history weight

$ w(h) prop q^(L(h)). $

Applying the weighted-history theorem [1] yields

$ P(m)=(1-r)r^m, quad
  r=(1-sqrt(1-4q^2))/(2q), $

or, in terms of total size,

$ P(n)=(1-r)r^(n-1), quad n>=1. $

The mean excess size is

$ ⟨m⟩=r/(1-r). $

Writing $x=-log r$ gives $⟨m⟩=1/(exp(x)-1)$, but this is only a change of
variable. No thermal interpretation of $x$ is made in this paper.

== What the benchmark proves

The benchmark proves a conditional statement:

#note[
Equal one-quantum branching probabilities plus a state-independent constant
escape hazard produce the complete-history factor $q^L$ and an exact geometric
endpoint law.
]

It does not prove that crossing a spatial boundary has a constant hazard, that
directional trajectories of equal length are equiprobable, or that blocking a
loss at $n=1$ is equivalent to killing the candidate. Those differences are
tested rather than ignored below.

= Six-direction spatial formation model

== Particle state and motion

A candidate particle is a finite nonempty list with entries in

$ cal(D)={R,L,U,D,F,B}, $

identified with the six signed coordinate vectors
$plus.minus e_x, plus.minus e_y, plus.minus e_z$. The candidate begins at the
center of a ball of radius $R$ with one random instruction.

At each tick:

+ Choose one list entry uniformly and execute a taxicab step of length $d$.
+ If the new position lies outside the ball, record the particle and stop.
+ Otherwise, attempt an encounter with probability $p$.
+ Choose a source point uniformly inside the ball. Quantize the displacement
  from source to particle to its dominant signed coordinate axis.
+ Accept the encounter only when the incoming axis is perpendicular to the
  active instruction's axis.
+ On acceptance, add the incoming instruction with probability $1/2$; otherwise
  remove the active instruction if $n>1$.

The last condition blocks loss at $n=1$ rather than killing the candidate. The
model therefore has a reflecting size boundary but an absorbing spatial
boundary. This is one reason the exact benchmark cannot be transferred without
qualification.

== Recorded observables

For every escaped particle the simulation records:

- endpoint size $n$;
- number $L$ of successful $plus.minus 1$ transitions;
- tick age $t$;
- internal normalized speed
  $v=norm(sum_i bold(d)_i)/n$; and
- angle between the net instruction vector and the exit radius.

The primary observable of this paper is $P(n)$. Motion and speed are diagnostics,
not part of the geometric-law claim.

== No manual path factor

The simulation does not choose a history length from a geometric distribution,
does not multiply trajectories by $q^L$, and does not stop with a fixed
probability per interaction. Escape occurs only when executed taxicab motion
crosses the sphere. Hence any approximate exponential survival or geometric
endpoint shape is produced by the coupled motion/exchange process.

= Fitting and error measures

For a sample of endpoints $n>=1$, the shifted geometric maximum-likelihood
parameter is determined by the sample mean:

$ hat(r)=(bar(n)-1)/bar(n). $

The fitted probability is

$ G_(hat(r))(n)=(1-hat(r))hat(r)^(n-1). $

Agreement is measured by total-variation distance

$ D_"TV"=1/2 sum_(n>=1) abs(P_"emp"(n)-G_(hat(r))(n)). $

$D_"TV"=0$ means identical distributions; $D_"TV"=1$ means disjoint support.
Because $hat(r)$ is estimated from the same endpoints, a small value demonstrates
shape agreement, not an independently predicted parameter. Section 7 therefore
performs a stronger held-out prediction test.

= Robustness sweep of endpoint geometry

The implementation `test_geometric_robustness.cpp` tested five radii

$ R in {0.5,1,2,3,5} $

and six Poisson encounter intensities

$ lambda in {0.03,0.1,0.3,1,3,10}. $

Each of the $30$ regimes used $60,000$ trajectories, for $1.8$ million total.
The Poisson formulation allows multiple encounters per tick and is a high-flux
extension of the one-attempt Vue implementation. All other directional,
perpendicular, gain/loss, and escape rules are the same.

Representative results are:

#block(breakable: false)[
#align(center)[
#table(
  columns: (0.8fr, 0.9fr, 1.1fr, 0.9fr, 1fr),
  align: (right, right, right, right, right),
  [$R$], [$lambda$], [$bar(n)$], [$hat(r)$], [$D_"TV"$],
  [0.5], [0.03], [1.136], [0.119], [0.0049],
  [0.5], [0.30], [2.094], [0.522], [0.0546],
  [1.0], [0.30], [2.989], [0.665], [0.0564],
  [2.0], [1.00], [9.195], [0.891], [0.0791],
  [3.0], [0.30], [5.620], [0.822], [0.0633],
  [5.0], [1.00], [15.828], [0.937], [0.0880],
  [5.0], [10.0], [60.038], [0.983], [0.1120],
)
]
]

Across all $30$ regimes,

$ 0.0049<=D_"TV"<=0.1120. $

The fit is strongest at low occupancy and gradually worsens in the largest,
highest-flux regimes. Tail-only TV contributions were approximately $0.004$ to
$0.061$. The result is robust approximate geometry, not an exact stationary
law.

= Are escape-history lengths exponential?

For a completed trajectory let $L$ count only successful size transitions, not
incompatible or rejected encounters. Define the survival function

$ S_L(ell)=P(L>=ell). $

If escape supplied a constant hazard per successful transition, the adjacent
survival ratio

$ q_"esc"(ell)=S_L(ell+1)/S_L(ell) $

would be constant. The implementation `test_escape_history_weight.cpp` used
$120,000$ trajectories at $R=3$ for each intensity. Over a central range with
at least $500$ surviving trajectories it measured:

#block(breakable: false)[
#align(center)[
#table(
  columns: (0.8fr, 1fr, 1fr, 1.1fr, 1fr),
  align: (right, right, right, right, right),
  [$lambda$], [$bar(L)$], [$R^2_"exp"$], [$bar(q)_"esc"$], [$"CV"(q)$],
  [0.1], [9.30], [0.9867], [0.8408], [0.0572],
  [0.3], [41.61], [0.9737], [0.9461], [0.0247],
  [0.5], [81.90], [0.9604], [0.9684], [0.0169],
  [1.0], [200.44], [0.9334], [0.9849], [0.0097],
  [2.0], [473.97], [0.9019], [0.9928], [0.0054],
)
]
]

Here $R^2_"exp"$ is the coefficient of determination of a linear fit to
$log S_L(ell)$, and $"CV"(q)$ is the coefficient of variation of adjacent
survival ratios. The central history-length survival is close to exponential,
especially at low and moderate intensity, but curvature becomes more visible at
high intensity.

The correlation $R^2$ between $L$ and tick age increased from $0.725$ at
$lambda=0.1$ to $0.941$ at $lambda=2$. Thus $L$ becomes increasingly close to a
linear clock, but it is not exactly proportional to time.

= Why one escape parameter is insufficient

If every successful transition were an independent fair gain/loss choice, the
probability of one specified branch would add a factor $1/2$. A tempting estimate
is therefore

$ q_"path" approx bar(q)_"esc"/2, $

followed by the exact Catalan map

$ r_"path"=(1-sqrt(1-4q_"path"^2))/(2q_"path"). $

This estimate has the required range $q_"path"<1/2$, but it systematically
underpredicts the endpoint parameter:

#block(breakable: false)[
#align(center)[
#table(
  columns: (0.8fr, 1fr, 1fr, 1fr),
  align: (right, right, right, right),
  [$lambda$], [$q_"path"$], [$r_"path"$], [$r_"endpoint"$],
  [0.1], [0.420], [0.546], [0.664],
  [0.3], [0.473], [0.715], [0.822],
  [0.5], [0.484], [0.775], [0.870],
  [1.0], [0.492], [0.839], [0.915],
  [2.0], [0.496], [0.887], [0.944],
)
]
]

The discrepancy has a physical interpretation. Spatial escape is correlated
with direction and composition; the reflecting size boundary biases gain/loss
histories; and paths of equal length are not equiprobable. Approximate
exponential length survival is therefore evidence for a path penalty, but not a
complete prediction of $P(n)$.

= Size-resolved absorbing-chain prediction

To retain the dominant state dependence, define a tick-scale coarse-grained
kernel

$ K_(n j)=P(n_(t+1)=j " and no escape" | n_t=n) $

and escape probability

$ a_n=P("escape on next tick" | n_t=n). $

These quantities were estimated from $80,000$ training trajectories. Starting
with unit mass at $n=1$, probability mass was propagated by $K$ and absorbed
through $a_n$. No geometric fit to the held-out endpoints was used. An independent
set of $80,000$ trajectories supplied the test distribution.

Results from `predict_endpoints_from_escape_chain.cpp` were:

#block(breakable: false)[
#align(center)[
#table(
  columns: (0.7fr, 0.8fr, 0.9fr, 1.1fr, 1fr),
  align: (right, right, right, right, right),
  [$R$], [$lambda$], [$hat(r)_"test"$], [geometric TV], [chain TV],
  [1], [0.1], [0.436], [0.0538], [0.0027],
  [1], [0.3], [0.665], [0.0588], [0.0032],
  [3], [0.1], [0.665], [0.0666], [0.0051],
  [3], [0.3], [0.823], [0.0633], [0.0071],
  [3], [1.0], [0.915], [0.0877], [0.0152],
  [5], [1.0], [0.937], [0.0960], [0.0133],
)
]
]

The size-resolved chain predicts held-out endpoints substantially better than a
one-parameter geometric fit. This does not prove that size alone is a fundamental
Markov state: direction and position have been averaged out. It shows that their
conditional effects are represented accurately enough by an empirical
size-dependent kernel for the tested regimes.

= Speed and anisotropy diagnostics

The normalized internal speed at exit is

$ v=1/n norm(sum_(i=1)^n bold(d)_i). $

Earlier exploratory runs suggested a possible large-size value near
$1/sqrt(3)$. A controlled comparison using the exact one-encounter-per-tick Vue
rules did not establish such a universal limit. With $R=20$, encounter
probability $0.95$, and perpendicular-only exchange, mean speeds were

#align(center)[
#table(
  columns: (1.2fr, 1fr, 1fr, 1fr),
  align: (left, right, right, right),
  [size range], [all exits], [axis-like], [diagonal-like],
  [$20$-$49$], [0.659], [0.714], [0.591],
  [$50$-$99$], [0.623], [0.671], [0.566],
  [$100$-$149$], [0.586], [0.627], [0.535],
  [$150$-$249$], [0.543], [-], [-],
)
]

The directional difference is substantial. Six fixed taxicab directions leave
microscopic anisotropy, and averaging over exits can pass near $1/sqrt(3)$ without
establishing a direction-independent attractor. Perpendicularity reduced speed
dispersion in separate controls but did not remove orientation dependence.
Consequently neither a universal speed nor emergent rotational invariance is a
result of this paper.

= Interpretation and limitations

The numerical evidence supports the following limited chain:

#note[
Directional one-quantum exchange plus boundary crossing generates approximately
exponential history survival and robust approximately geometric endpoint sizes.
A size-resolved absorbing kernel predicts the residual deviations accurately in
held-out simulations.
]

The evidence does not support stronger claims:

- The full spatial law is not exactly geometric.
- A single measured $q_"esc"$ does not determine the endpoint ratio.
- Gain/loss probability $1/2$ is a modeling assumption, not a derived physical
  law.
- The dominant-axis source quantization retains taxicab anisotropy.
- The Poisson high-flux sweep is not identical to the browser's Bernoulli
  one-encounter-per-tick implementation.
- No link from interaction intensity to thermodynamic temperature is derived.
- No Planck density-of-states factor, low-energy suppression, tired-light law,
  cosmological reset, or matter-creation process is included.

The spherical model is therefore best regarded as a constructive open-system
example and a source of quantitative targets for future microscopic exchange
rules.

= Reproducibility

The principal programs are:

- `test_geometric_robustness.cpp` - $30$-regime endpoint sweep;
- `test_escape_history_weight.cpp` - history survival and one-$q$ test;
- `predict_endpoints_from_escape_chain.cpp` - held-out absorbing-chain test;
- `test_vue_large_n_perpendicular.cpp` - speed and anisotropy diagnostic; and
- `DirectionalSourceEscape.vue` - interactive browser realization.

The public project repository is
#link("https://github.com/matterasmachine/matterasmachine")[github.com/matterasmachine/matterasmachine].
A final content-bearing commit or release containing this manuscript and all five
listed implementations must be cited before publication. Numerical tables in
this draft correspond to the source files in the local development tree on
2026-07-03. Fixed pseudorandom seeds are embedded in the C++ programs; exact
bitwise output may still depend on the standard-library implementation of random
distributions.

= Conclusion

An independent constant escape clock supplies an exact physical realization of
the complete-history weight $q^L$ and therefore an exact shifted geometric
endpoint law. Spatial boundary crossing is richer: its hazard depends on
position, direction, composition, and the history that brought the particle
there. It does not satisfy the exact benchmark.

Even so, the directional spherical process produces a stable approximate
geometric shape across a broad parameter sweep. Its history survival is close to
exponential over a central range, and a size-resolved absorbing Markov chain
predicts independent endpoint samples with roughly $0.3%$-$1.5%$ TV error in the
six reported regimes. These observations identify escape as a plausible
dynamical source of length suppression while showing why a single scalar $q$
cannot capture the complete spatial process.

The next theoretical task is not to impose a more elaborate target distribution.
It is to specify microscopic transfer rules that determine the state-dependent
kernel analytically and to test whether a controlled limit reduces that kernel to
the exact constant-hazard benchmark.

= References

#set par(hanging-indent: 1.6em)

[1] Matter-as-machine, "Geometric Occupancy from Weighted One-Quantum
Gain/Loss Histories: Relation to Bose-Einstein and Planck Forms," unpublished
note, 2026.

[2] Matter-as-machine, "Thermodynamic Equilibrium from Reversible One-Quantum
Exchange among Discrete Particles," unpublished note and reproducibility
archive, 2026.

[3] Y. Sun and F. Ma, "Some New Binomial Sums Related to the Catalan Triangle,"
_Electronic Journal of Combinatorics_ *21* (2014), Paper P1.33.
#link("https://doi.org/10.37236/3701")[doi:10.37236/3701].

[4] V. Giorno and A. G. Nobile, "Bell Polynomial Approach for
Time-Inhomogeneous Linear Birth-Death Process with Immigration," _Mathematics_
*8* (2020), 1123.
#link("https://doi.org/10.3390/math8071123")[doi:10.3390/math8071123].

[5] J. R. Norris, _Markov Chains_, Cambridge University Press, 1997, chapters
1-2.

#set heading(numbering: none)

= Appendix A: exact benchmark in discrete event time

The same benchmark can be written without exponential clocks. At each effective
event choose gain with probability $q$, loss with probability $q$, and escape
with probability $1-2q$, where $0<q<1/2$. A particular allowed history of length
$L$ followed by escape then has probability

$ (1-2q)q^L. $

Conditioning on successful escape removes the common factor $1-2q$, leaving the
weighted-history ensemble of [1]. Continuous time determines waiting times but
is not required for the endpoint theorem.

= Appendix B: implementation distinctions

The interactive Vue implementation attempts at most one encounter per tick with
Bernoulli probability $p$. The robustness and absorbing-chain C++ programs use a
Poisson number of encounters per tick with mean $lambda$, allowing multiple
events at high flux. Both versions execute one motion instruction before testing
escape and use the same uniform source ball, dominant-axis quantization,
perpendicular compatibility, reflecting size boundary, and fair gain/loss
choice. Results from the two encounter schedules should not be numerically
identified without a small-$p,lambda$ scaling analysis.
