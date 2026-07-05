#set page(
  paper: "a4",
  margin: (top: 19mm, bottom: 19mm, left: 24mm, right: 24mm),
  numbering: "1",
  number-align: center + bottom,
)
#set text(font: "New Computer Modern", size: 9.4pt, lang: "en")
#set par(justify: true, leading: 0.52em)
#set heading(numbering: "1.")
#show heading.where(level: 1): it => block(above: 1.25em, below: 0.6em)[
  #set text(size: 13.2pt, weight: "semibold", fill: rgb("173f68"))
  #it
]
#show heading.where(level: 2): it => block(above: 1em, below: 0.45em)[
  #set text(size: 11.3pt, weight: "semibold", fill: rgb("173f68"))
  #it
]
#show math.equation.where(block: true): set block(above: 0.75em, below: 0.75em)
#set list(indent: 1.1em, body-indent: 0.55em)
#set table(stroke: rgb("c8d2df"), inset: 5pt)

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
    Thermodynamic Equilibrium from Reversible #linebreak()
    One-Quantum Exchange among Discrete Particles
  ]
  #v(3mm)
  #text(size: 11.5pt, weight: "medium", fill: rgb("173f68"))[
    A finite-state counting argument and numerical realization
  ]
  #v(7mm)
  #text(size: 10.5pt)[
    #link("https://x.com/matterasmachine")[Matter-as-machine]
  ]
]

#v(6mm)
#align(center)[#text(weight: "semibold", size: 11.5pt)[Abstract]]
#v(2mm)

This note studies a minimal model of thermodynamic exchange among discrete
particles. A particle is postulated to be a nonempty finite list of quanta
and is constrained to remain at size $n>=1$. Relative to that minimum size, it
has excess occupancy $m=n-1$. No particular list entry is a persistent baseline:
an elementary event may transfer any selected quantum provided that the donor
remains nonempty. Each transferred quantum carries energy $epsilon$, and total
exchange energy is conserved. For $M$ particles and $Q$ excess
quanta, and under an explicit occupancy-level coarse-graining, the number of
configurations is
$binom(Q+M-1,Q)$. The uniform microcanonical measure therefore has an exact
finite-system marginal distribution and, in the thermodynamic limit at fixed
$nu=Q/M$, a geometric marginal
$P(m)=(1-r)r^m$ with $r=nu/(1+nu)$. Defining entropy by
$S=k log Omega$ and temperature by $1/T=(partial S)/(partial E)$ gives
$r=exp[-epsilon/(k T)]$ and
$⟨m⟩=1/[exp(epsilon/(k T))-1]$. Thus the exponential thermal
parameter is obtained from state counting rather than inserted as a change of
variables. For a specified size-independent per-particle transfer kernel, a
reversible one-quantum Markov process is shown to have the uniform
microcanonical measure as its unique stationary distribution. Time-averaged,
multiple-seed simulations of two initially unequal reservoirs agree with the
exact finite marginal. The result is a
minimal thermodynamics of a fixed-energy exchange ensemble, not a derivation of quantum
mechanics, a full Bose gas, or the Planck spectrum.

= Purpose and scope

The central question is deliberately narrow:

#note[
Can temperature and a Bose-Einstein-shaped mean occupancy arise from a concrete
one-quantum exchange process among discrete particles, without first imposing
the substitution $r=exp[-epsilon/(k T)]$?
]

The answer is yes for the idealized model defined below. The result has two
parts:

- a counting result that determines the equilibrium distribution and its
  temperature parameter; and
- a stochastic dynamics that actually approaches that equilibrium by reversible
  one-quantum transfers.

The contribution is a deliberately simpler route to familiar equilibrium
relations: standard thermodynamic quantities and a Bose-Einstein-shaped
single-energy occupancy arise from discrete reversible matter exchange, without
assuming an exponential thermal factor or the machinery of quantum mechanics.
The coarse-graining and kinetic kernel required for that result are stated
explicitly below.

#note[
*Ontological postulate.* Matter is discrete. A particle is identified with a
finite nonempty list of elementary instructions, not merely represented by such
a list for mathematical convenience. The empty list represents absence of a
particle. Consequently, an existing particle has total length $n>=1$. Writing
$n=1+m$, the exchangeable occupancy satisfies $m>=0$. The condition $n>=1$ is
a boundary on total list length; it does not label any particular instruction
as a protected baseline.
]

#note[
*Thermodynamic coarse-graining postulate.* Instruction identity, direction, and
position in a list may matter to other dynamics, but they are not resolved by
the present equilibrium model. Its energy and thermodynamic state depend only
on the occupancies $(m_1,dots,m_M)$. Occupancy configurations are assigned equal
weight. Equivalently, any unresolved list-level degeneracy is assumed to give
the same multiplicative factor to every fixed-$Q$ occupancy configuration. This
postulate is essential: if list order or instruction identity gives
occupancy-dependent multiplicities, the stars-and-bars measure and the results
below need not follow.
]

This paper establishes consequences of that postulate only within the stated
reversible exchange model. It does not establish that real elementary particles
possess this structure.

Mathematically, the counting is the familiar distribution of indistinguishable
quanta among distinguishable containers and is closely related to standard
Bose-Einstein occupancy counting. At the level of stochastic occupancy dynamics,
the model also overlaps with zero-range and related particle-transfer processes
[6]. The claim is therefore not that the combinatorial formula or the general
transfer-process mathematics is new. The distinct claim is interpretive: the
occupancies are proposed as the literal discrete internal matter of particles,
not as site occupancies in an auxiliary stochastic model. Scientific support for
that ontology requires distinctive empirical predictions beyond reproducing
established equilibrium statistics.

Several topics are intentionally excluded. There is no spatial escape in the
equilibrium derivation, no cosmological loss or "tired light," no creation of
matter, and no pressure-volume law. These belong to separate models and should
not be used to justify the equilibrium result proved here.

= Discrete particles and conserved exchange energy

Consider $M>=2$ distinguishable particles. Particle $i$ has total list length

$ n_i=1+m_i, quad m_i in {0,1,2,dots}. $

The constraint $n_i>=1$ ensures that a particle always exists. The variable
$m_i=n_i-1$ is a count relative to this minimum, not a label attached to a
protected instruction. Whenever $n_i>1$, any selected instruction may be
transferred while leaving at least one instruction behind. Each transferred
instruction carries the same energy $epsilon>0$. Hence

$ E_i=epsilon m_i, quad
  E=sum_(i=1)^M E_i=epsilon Q, quad
  Q=sum_(i=1)^M m_i. $

An elementary exchange transfers one excess instruction:

$ (m_i,m_j) arrow.r (m_i-1,m_j+1), quad m_i>=1. $

The reverse event is also allowed. Every event conserves $Q$ and therefore $E$.
No instruction is created or destroyed in this closed model.

The minimum-size subtraction is an energy convention, not a persistent physical
quantum. If the total list energy is instead defined as $epsilon n_i$, every
particle receives the same additive offset $epsilon$. The total energy then
changes by $M epsilon$, but exchange probabilities, entropy differences,
temperature, and the distribution of $m_i$ are unchanged.

= Exact finite-system state counting

== Number of configurations

A microconfiguration at the occupancy level is an ordered $M$-tuple

$ (m_1,dots,m_M), quad m_i>=0, quad sum_i m_i=Q. $

The number of such weak compositions is the stars-and-bars count

$ Omega(Q,M)=binom(Q+M-1,Q)=binom(Q+M-1,M-1). $

The coarse-graining postulate assigns all these occupancy configurations equal
weight. Section 6 supplies an explicit occupancy-level Markov process for which
the corresponding uniform stationary probability follows from detailed balance
and ergodicity. It does not derive that coarse-graining from finer list-level
dynamics.

== Exact marginal of one particle

Fix $m_1=m$. The remaining $Q-m$ quanta may be distributed among $M-1$
particles in

$ Omega(Q-m,M-1)=binom(Q-m+M-2,Q-m) $

ways. Therefore the exact finite-system marginal is

$ P_(Q,M)(m)=
  binom(Q-m+M-2,Q-m) / binom(Q+M-1,Q),
  quad 0<=m<=Q. $

Its adjacent ratio is

$ frac(P_(Q,M)(m+1), P_(Q,M)(m))
  =(Q-m)/(Q-m+M-2). $

This ratio depends weakly on $m$ at finite $Q$ and $M$. Consequently the exact
finite marginal is not exactly geometric. That distinction matters: the
geometric law appears as a controlled thermodynamic-limit result, not as an
identity for every finite ensemble.

== Thermodynamic limit

Let $Q,M arrow.r infinity$ while the mean excess occupancy

$ nu=Q/M $

remains fixed. For each fixed $m$,

$ (Q-m)/(Q-m+M-2) arrow.r Q/(Q+M)=nu/(1+nu)=r. $

Normalization then gives

$ P(m)=(1-r)r^m, quad m>=0, quad
  r=nu/(1+nu). $

The mean of this distribution is

$ ⟨m⟩=r/(1-r)=nu. $

Thus the geometric law is both the limiting marginal of uniform compositions
and the distribution whose mean equals the conserved excess occupancy per
particle.

= Entropy and the emergence of temperature

Define microcanonical entropy by

$ S(E,M)=k log Omega(Q,M), quad Q=E/epsilon, $

where $k$ fixes the temperature unit. Because energy is discrete, define the
finite-system inverse temperature by the entropy gained when one quantum is
added:

$ 1/T_(Q,M):=(S(Q+1,M)-S(Q,M))/epsilon
  =(k/epsilon)log((Q+M)/(Q+1)). $

This is exact. In the thermodynamic limit it approaches

$ 1/T=(k/epsilon)log((Q+M)/Q)
  =(k/epsilon)log(1+1/nu). $

The same limiting expression follows from the usual derivative. Using
Stirling's approximation at large $Q$ and $M$ gives

$ S/k approx
  (Q+M)log(Q+M)-Q log Q-M log M. $

In terms of $nu=Q/M$,

$ S approx k M [(1+nu)log(1+nu)-nu log nu]. $

For the smooth limiting entropy, temperature is equivalently

$ 1/T=(partial S)/(partial E)_M. $

Applying this derivative and using $E=epsilon Q$ reproduces

$ 1/T approx (k/epsilon) log((Q+M)/Q)
     =(k/epsilon) log(1+1/nu). $

Equivalently, in that same limit,

$ epsilon/(k T) approx log(1+1/nu). $

Solving the limiting relation for $nu$ yields

$ nu=⟨m⟩
  =1/(exp(epsilon/(k T))-1). $

The limiting geometric ratio becomes

$ r=nu/(1+nu)=exp[-epsilon/(k T)]. $

The full limiting marginal is therefore

$ P(m)=
  (1-exp[-epsilon/(k T)]) exp[-m epsilon/(k T)]. $

#note[
The exponential factor has not been postulated. It follows from the logarithmic
growth of the number of configurations and the thermodynamic definition
$ 1/T=frac(partial S, partial E). $
]

This is the mathematical single-energy Bose-Einstein occupancy form. It is not
yet the full distribution of radiation over frequency. A Planck spectrum also
requires an energy label such as $epsilon=ℏ omega$, a density of states, and
the appropriate photon interpretation.

= Thermodynamic relations of the ideal exchange ensemble

The relations in this section use the thermodynamic-limit temperature obtained
in Section 4. They are not asserted as exact finite-$M,Q$ identities.

== Internal energy

The mean exchange energy per particle is

$ u(T)=epsilon ⟨m⟩
     =epsilon/(exp(epsilon/(k T))-1). $

For $M$ particles,

$ U(T,M)=M epsilon/(exp(epsilon/(k T))-1). $

Any baseline energy is additive and omitted here.

== Heat capacity

Let $x=epsilon/(k T)$. Differentiation gives the heat capacity per particle

$ c(T)=(dif u)/(dif T)
  =k x^2 exp(x)/(exp(x)-1)^2>0. $

At high temperature, $x ≪ 1$ and

$ u(T) approx k T-epsilon/2+O(T^(-1)), quad c(T) arrow.r k. $

At low temperature,

$ u(T) approx epsilon exp[-epsilon/(k T)], quad c(T) arrow.r 0. $

== Zeroth law: an operational temperature

Place two subsystems $A$ and $B$ in weak exchange contact while conserving
$E_A+E_B$. The total multiplicity is

$ Omega_"tot"(E_A)=Omega_A(E_A)Omega_B(E-E_A), $

and the most probable division maximizes
$S_"tot"=S_A+S_B$. At the maximum,

$ (partial S_A)/(partial E_A)
  =(partial S_B)/(partial E_B), $

so

$ 1/T_A=1/T_B. $

Within the stated symmetric, connected exchange model, two bodies have the same
temperature when their late-time mean energy flux vanishes. Outside this model,
vanishing flux alone is not sufficient: kinetic blocking or disconnected exchange
channels can also prevent a flux between unequal states. This criterion is stronger
than identifying temperature with an
interaction frequency: changing the event rate changes how quickly equilibrium
is reached, whereas changing $Q/M$ changes which equilibrium is reached.

== First law in the closed exchange model

Every transfer removes one quantum from one particle and gives it to another.
Therefore

$ Delta E_A+Delta E_B=0. $

There is heat exchange but no work term in the present model. Its first-law
content is simply conservation of exchange energy.

== Equilibrium concentration and typicality

Starting far from equilibrium, overwhelmingly more configurations correspond to
energy divisions near the maximum of $S_A+S_B$ than to extreme divisions. The
irreducible exchange process of Section 6, whose stationary measure is
uniform, therefore approaches the high-multiplicity region with high
probability. Microscopic trajectories can fluctuate away from
it; the statistical claim is that the equilibrium macrostate dominates for
large systems. This is an equilibrium concentration statement, not a proof that
entropy increases monotonically along every stochastic trajectory.

The model also has a simple low-temperature limit. As $T arrow.r 0$,
$nu arrow.r 0$, all excess occupancies vanish, and the unique occupancy
configuration is $m_i=0$ for every particle. Hence $S arrow.r 0$ within this
idealized occupancy description.

= Reversible one-quantum exchange dynamics

The counting above describes equilibrium. We now give a process that reaches it.
At each discrete update:

+ Choose an ordered pair of distinct particles $(i,j)$ uniformly.
+ If $m_i>0$, transfer one quantum from $i$ to $j$.
+ If $m_i=0$, perform no transfer.

Uniform selection of the donor *particle*, rather than uniform selection among
all transferable instructions, is an independent kinetic postulate of this
model. It makes the attempted transfer rate size-independent. Discreteness and
reversibility alone do not select this kernel: choosing instructions uniformly
would make donor rates occupancy-dependent and can produce a different
stationary measure. A physical application must therefore justify or test the
size-independent per-particle interaction rate.

For any two neighboring configurations $a$ and $b$ connected by moving one
quantum from $i$ to $j$,

$ P(a arrow.r b)=1/[M(M-1)]=P(b arrow.r a). $

Thus the transition matrix is symmetric on every allowed edge. The uniform
measure

$ pi(a)=1/Omega(Q,M) $

satisfies detailed balance:

$ pi(a)P(a arrow.r b)=pi(b)P(b arrow.r a). $

The state graph is connected because quanta can be transferred one at a time
between any particles. The self-loops at empty donors make the chain aperiodic.
The finite chain is therefore irreducible and aperiodic, so the uniform
microcanonical distribution is its unique stationary law and the process
converges to it from every initial configuration.

This argument identifies the essential assumptions:

- one-quantum transfers;
- conservation of $Q$;
- reversibility with equal forward and reverse edge weights; and
- sufficient connectivity to explore the full fixed-$Q$ state space.

The first item alone is not sufficient; the equal edge weights generated by
uniform particle-pair selection are what make the stationary measure uniform.

If physical exchange rules violate these conditions, a different stationary
law may result.

= Two-reservoir numerical experiment

== Reversible exchange model

The implementation `two_bath_reversible_exchange.cpp` uses two reservoirs with
$1000$ particles each. Reservoir $A$ begins with mean excess occupancy $8$ and
reservoir $B$ with mean excess occupancy $1$. Thus the conserved global mean is

$ nu_"global"=(8+1)/2=4.5. $

Eight runs use consecutive fixed seeds. Each run has $5$ million burn-in updates
followed by $20$ million measured updates; the full $2000$-particle histogram is
sampled every $100,000$ measured updates. The resulting time-averaged values,
reported as mean $plus.minus$ sample standard deviation across runs, are

#block(breakable: false)[
#align(center)[
#table(
  columns: (1.55fr, 1fr, 1fr, 1.2fr),
  align: (left, right, right, right),
  [quantity], [mean], [run SD], [target],
  [$nu_A$], [4.50719], [0.00926], [4.50000],
  [$nu_B$], [4.49282], [0.00926], [4.50000],
  [net cross-flux], [$-4 times 10^(-6)$], [$1.7 times 10^(-5)$], [0],
)
]
]

The equilibrium parameters predicted from the conserved global mean are

$ r=4.5/5.5=0.818182, quad
  beta epsilon=log(1+1/4.5)=0.200671. $

The reservoir means fluctuate around $4.5$ rather than remaining exactly equal,
as expected for finite systems.

== Exact finite-law test

The code constructs the exact finite marginal $P_(9000,2000)(m)$ from its
adjacent ratio, without fitting a parameter to either reservoir. It then compares
that prediction with the pooled post-burn-in histogram. Across the eight runs,

$ "TV(exact)"=0.002702 plus.minus 0.000186. $

For reference, comparison with the thermodynamic-limit geometric law fixed by
the conserved global mean $nu=4.5$ gives

$ "TV(geometric)"=0.002715 plus.minus 0.000162. $

To quantify temporal dependence, the code estimates the integrated
autocorrelation time of the $nu_A$ snapshot series by summing positive empirical
autocorrelations. Across runs,

$ tau_"int"=1.108 plus.minus 0.235 " snapshots", quad
  "ESS"=92.98 plus.minus 14.75 $

out of 200 stored snapshots per run. These spreads are sample standard
deviations across eight runs, not confidence intervals. Particle values within
a snapshot are also constrained by fixed $Q$, so these diagnostics do not prove
that the TV discrepancy is mostly sampling noise. They show close finite-run
agreement with the exact law at the tested scale.

= Relation to Bose-Einstein statistics

The limiting marginal

$ P(m)=(1-exp[-beta epsilon])exp[-beta epsilon m] $

and mean

$ ⟨m⟩=1/(exp(beta epsilon)-1) $

are the standard single-energy bosonic occupancy formulas at zero chemical
potential. Bose's original radiation counting and Einstein's extension to an
ideal gas established the historical quantum-statistical setting for these
expressions [1, 2].

The present construction differs in interpretation: the containers are
identified with finite nonempty discrete particles and the quanta with
transferable list entries. The boundary of the result—single energy rather than
a spectrum, occupancy mathematics rather than quantum mechanics, and closed
equilibrium rather than formation or escape—is collected in Section 9.

= What has and has not been derived

Within the stated model, the following results are derived:

- the exact finite marginal $P_(Q,M)(m)$;
- its geometric thermodynamic limit;
- entropy $S=k log Omega$;
- the thermodynamic-limit temperature relation
  $r=exp[-epsilon/(k T)]$;
- the Bose-Einstein-shaped mean occupancy;
- internal energy and heat capacity;
- equality of temperature as the condition for maximal total entropy and zero
  late-time mean flux; and
- convergence of a specified reversible exchange chain to the microcanonical
  equilibrium.

The following are not derived:

- the microscopic origin or numerical value of $epsilon$;
- the physical identity of the transferable quanta;
- the Planck spectral factor or density of states;
- pressure, volume, mechanical work, or an equation of state;
- chemical potential when particle number changes;
- creation, annihilation, reset events, or cosmological redshift; and
- quantum mechanics or the ontology of real elementary particles.

This boundary is not cosmetic. It separates a reproducible mathematical result
from hypotheses that require additional dynamics and empirical tests.

= Reproducibility

The simulations are deterministic given their pseudorandom seeds and are
implemented in the accompanying source files:

- `two_bath_reversible_exchange.cpp`: symmetric reversible exchange between two
  initially unequal reservoirs.

The reproducibility archive is the public repository
#link("https://github.com/matterasmachine/matterasmachine")[github.com/matterasmachine/matterasmachine].
The exact source revision associated with this manuscript is commit
#link("https://github.com/matterasmachine/matterasmachine/commit/f46f9f5fd6bb6b4e3bcbe4d1c48fccfca8055825")[`f46f9f5fd6bb6b4e3bcbe4d1c48fccfca8055825`].
The corresponding project folder is available
#link("https://github.com/matterasmachine/matterasmachine/tree/f46f9f5fd6bb6b4e3bcbe4d1c48fccfca8055825/thermodynamic-exchange")[at this immutable revision].
No DOI has yet been assigned.

The simulation is not an independent proof of equilibrium: detailed balance
already supplies that proof. It validates the implementation, demonstrates
convergence from unequal reservoirs, and measures finite-run agreement with the
exact marginal. The reported run-to-run standard deviations and ESS diagnostics
are not confidence intervals or precision estimates of universal constants.

= Conclusion

A minimal reversible exchange process among nonempty discrete particles,
together with the stated coarse-graining and size-independent particle-pair
kernel, produces a coherent ideal thermodynamics. Uniform fixed-energy
configurations have an exact finite marginal that approaches a geometric law.
The logarithm of their multiplicity supplies entropy; differentiating entropy
with respect to energy supplies temperature; and the resulting
thermodynamic-limit geometric ratio is $r=exp[-epsilon/(k T)]$. A symmetric
one-quantum Markov process converges to
this equilibrium, while two-reservoir simulations show energy equalization and
vanishing late-time net flux.

The main conceptual result is therefore modest but concrete:

#note[
Within the stated occupancy coarse-graining and exchange kernel, for discrete
particles that reversibly exchange conserved equal-energy quanta,
temperature measures the equilibrium energy-per-particle scale selected by the
number of accessible configurations. The Bose-Einstein denominator is the
resulting occupancy relation, not an independently imposed exponential rule.
]

= References

#set par(hanging-indent: 1.6em)

[1] S. N. Bose, "Plancks Gesetz und Lichtquantenhypothese," _Zeitschrift
für Physik_ *26* (1924), 178-181.
#link("https://doi.org/10.1007/BF01327326")[doi:10.1007/BF01327326].

[2] A. Einstein, "Quantentheorie des einatomigen idealen Gases,"
_Sitzungsberichte der Preussischen Akademie der Wissenschaften,
Physikalisch-mathematische Klasse_ (1924), 261-267.
#link("https://doi.org/10.48644/1800487088")[doi:10.48644/1800487088].

[3] L. Boltzmann, "Über die Beziehung zwischen dem zweiten Hauptsatze der
mechanischen Wärmetheorie und der Wahrscheinlichkeitsrechnung respektive den
Sätzen über das Wärmegleichgewicht," _Wiener Berichte_ *76* (1877), 373-435.

[4] R. K. Pathria and P. D. Beale, _Statistical Mechanics_, 3rd ed.,
Elsevier, 2011, chapters 1, 3, and 7.

[5] Matter-as-machine, "Geometric Occupancy from Weighted One-Quantum
Gain/Loss Histories: Relation to Bose-Einstein and Planck Forms," unpublished
note, 2026.

[6] M. R. Evans and T. Hanney, "Nonequilibrium Statistical Mechanics of the
Zero-Range Process and Related Models," _Journal of Physics A: Mathematical and
General_ *38* (2005), R195-R240.
#link("https://doi.org/10.1088/0305-4470/38/19/R01")[doi:10.1088/0305-4470/38/19/R01].

#set heading(numbering: none)

= Appendix A: finite marginal and geometric convergence

For completeness, expand the exact marginal as a product. From the adjacent
ratio,

$ P_(Q,M)(m)=P_(Q,M)(0)
  product_(j=0)^(m-1) (Q-j)/(Q-j+M-2). $

Also,

$ P_(Q,M)(0)=(M-1)/(Q+M-1). $

At fixed $nu=Q/M$ and fixed $m$,

$ P_(Q,M)(0) arrow.r 1/(1+nu)=1-r $

and every factor in the finite product approaches

$ Q/(Q+M)=nu/(1+nu)=r. $

Therefore

$ P_(Q,M)(m) arrow.r (1-r)r^m. $

The restriction to fixed $m$ is the ordinary pointwise thermodynamic-limit
statement. Uniform error bounds over a range of $m$ require specifying how that
range grows with $M$.
