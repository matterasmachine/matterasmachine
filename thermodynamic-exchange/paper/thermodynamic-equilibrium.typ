#set page(
  paper: "a4",
  margin: (top: 19mm, bottom: 19mm, left: 24mm, right: 24mm),
  numbering: "1",
  number-align: center + bottom,
)
#set text(font: "New Computer Modern", size: 9.35pt, lang: "en")
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
    Geometric Equilibrium from a Specified Reversible #linebreak()
    Exchange Model of Discrete Particle Interiors
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
particles. A particle is postulated to be a nonempty finite cyclic list of
elementary instructions governing its microscopic motion and is constrained to
remain at size $n>=1$. Relative to that minimum size, it
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
$⟨m⟩=1/[exp(epsilon/(k T))-1]$. Thus state counting fixes the geometric
parameter consistently with the adopted thermodynamic definition of
temperature. For a specified symmetric encounter-and-transfer kernel, a
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
finite nonempty cyclic list of elementary instructions governing its
microscopic motion, not merely represented by such a list for mathematical
convenience. The empty list represents absence of a particle. Consequently, an
existing particle has total length $n>=1$. Writing $n=1+m$, the exchangeable
occupancy satisfies $m>=0$. The condition $n>=1$ is a boundary on total list
length; it does not label any particular instruction as a protected baseline.
The particle acts externally as one object irrespective of list length. At each
microscopic moment, exactly one current instruction is exposed to interaction;
the remaining entries are not simultaneous interaction opportunities.
]

Serial exposure also motivates inertia: changing one entry alters a length-$n$
particle's normalized composition by order $1/n$, so the same interaction rate
changes a longer list's motion more slowly. This resembles $a prop 1/m$ in
Newton's second law, but is not a derivation of $F=m a$.

The instruction alphabet, its internal attributes, and the microscopic
compatibility rules governing transfer are intentionally not specified in this
work. They belong to a separate microscopic theory. The present theorem begins
only after those unknown rules are projected to an occupancy-level exchange
process.

#note[
*Thermodynamic coarse-graining postulate.* Instruction identity, internal
attributes, and position in a list may matter to microscopic dynamics, but they
are not resolved by the present equilibrium model. Its energy and thermodynamic
state depend only on the occupancies $(m_1,dots,m_M)$. Occupancy configurations
are assigned equal weight. Equivalently, any unresolved list-level degeneracy
is assumed to give the same multiplicative factor to every fixed-$Q$ occupancy
configuration. This postulate is essential: if list order or instruction
identity gives occupancy-dependent multiplicities, the stars-and-bars measure
and the results below need not follow.
]

This paper establishes consequences of that postulate only within the stated
reversible exchange model. It does not establish that real elementary particles
possess this structure.

Mathematically, the counting is the familiar distribution of indistinguishable
quanta among distinguishable containers and is closely related to standard
Bose-Einstein occupancy counting. At the level of stochastic occupancy dynamics,
the model also overlaps with zero-range and related particle-transfer processes
[5]. The claim is therefore not that the combinatorial formula or the general
transfer-process mathematics is new. The distinct claim is interpretive: the
occupancies are proposed as the literal discrete internal matter of particles,
not as site occupancies in an auxiliary stochastic model. Scientific support for
that ontology requires distinctive empirical predictions beyond reproducing
established equilibrium statistics.

The present result concerns a closed fixed-energy exchange ensemble. Extensions
to spatial transport or open-system boundary processes require additional
dynamics.

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

= Entropy and thermodynamic parametrization

Define microcanonical entropy by

$ S(E,M)=k log Omega(Q,M), quad Q=E/epsilon, $

where $k$ fixes the temperature unit. Because energy is discrete, one possible
finite-system convention is the forward-difference inverse temperature obtained
when one quantum is added:

$ 1/T_(Q,M):=(S(Q+1,M)-S(Q,M))/epsilon
  =(k/epsilon)log((Q+M)/(Q+1)). $

This formula is exact for that convention, but the convention is not unique:
backward and centered differences give different finite-$Q$ values. Their
differences vanish in the thermodynamic limit, where the forward expression
approaches

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
The counting model supplies the value of the geometric parameter consistent
with $S=k log Omega$ and the thermodynamic definition of temperature. It does
not independently derive that definition.
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
$E_A+E_B$. This argument assumes that both use the same quantum energy
$epsilon$ and that one-quantum exchanges between them are allowed. If their
energy spacings differ, the allowed transfers and equilibrium condition require
additional specification. The total multiplicity is

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

Energy transferred between the two subsystems may be classified as heat. The
closed composite exchanges no heat with an environment and has no work term;
its first-law content here is conservation of exchange energy.

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

+ Choose an ordered pair of distinct particles $(i,j)$ with probability
  $c_(i j)$, where $c_(i j)=c_(j i)$ and the encounter graph is connected.
+ If $m_i>0$, transfer one quantum from $i$ to $j$.
+ If $m_i=0$, perform no transfer.

The particles need not encounter every other particle equally often. The theorem
requires only that the same physical encounter has no donor-label bias,
$c_(i j)=c_(j i)$, and that the accessible encounter graph is connected. The
single-current-instruction postulate explains why a particle of length $n$ does
not present $n$ simultaneous transfer opportunities. Thus the attempted
transfer rate per encounter need not scale with occupancy. Selecting uniformly
among every stored instruction instead would create occupancy-dependent donor
rates and can produce a different stationary measure.

For any two neighboring configurations $a$ and $b$ connected by moving one
quantum from $i$ to $j$,

$ P(a arrow.r b)=c_(i j)=c_(j i)=P(b arrow.r a). $

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

The first item alone is not sufficient; symmetric forward and reverse edge
weights are what make the stationary measure uniform. Uniform particle-pair
selection is only the special case used in the numerical implementation.

If physical exchange rules violate these conditions, a different stationary
law may result.

= Two-reservoir numerical experiment

== Reversible exchange model

The implementation `two_bath_reversible_exchange.cpp` uses two reservoirs with
$1000$ particles each. Reservoir $A$ begins with mean excess occupancy $8$ and
reservoir $B$ with mean excess occupancy $1$. Thus the conserved global mean is

$ nu_"global"=(8+1)/2=4.5. $

Initialization starts every occupancy at zero, then assigns $8000$ quanta
independently and uniformly among the particles of $A$ and $1000$ among those of
$B$. Eight runs use the explicit seeds $2026070403$ through $2026070410$. Each
run has $5$ million burn-in updates
followed by $20$ million measured updates; the full $2000$-particle histogram is
sampled every $20,000$ measured updates. The resulting time-averaged values,
reported as mean $plus.minus$ sample standard deviation across runs, are

#block(breakable: false)[
#align(center)[
#table(
  columns: (1.55fr, 1fr, 1fr, 1.2fr),
  align: (left, right, right, right),
  [quantity], [mean], [run SD], [target],
  [$nu_A$], [4.50819], [0.00929], [4.50000],
  [$nu_B$], [4.49181], [0.00929], [4.50000],
  [net cross-flux], [$-4 times 10^(-6)$], [$1.7 times 10^(-5)$], [0],
)
]
]

The equilibrium parameters predicted from the conserved global mean are

$ r=4.5/5.5=0.818182, quad
  beta epsilon=log(1+1/4.5)=0.200671. $

The reservoir means fluctuate around $4.5$ rather than remaining exactly equal,
as expected for finite systems.

The reported net cross-flux is

$ (N_(A arrow.r B)-N_(B arrow.r A))/N_"cross attempts", $

where the denominator counts every measured update whose ordered donor-receiver
pair crosses the reservoir boundary, including attempts with an empty donor.

== Exact finite-law test

The code constructs the exact finite marginal $P_(9000,2000)(m)$ from its
adjacent ratio, without fitting a parameter to either reservoir. It then compares
that prediction with the pooled post-burn-in histogram. Across the eight runs,

$ "TV(exact)"=0.001396 plus.minus 0.000179. $

For reference, comparison with the thermodynamic-limit geometric law fixed by
the conserved global mean $nu=4.5$ gives

$ "TV(geometric)"=0.001414 plus.minus 0.000180. $

#figure(
  image("thermodynamic-simulation-and-fits.png", width: 100%),
  caption: [
    Post-burn-in reversible-exchange simulation (bars), the exact finite
    marginal (red), and the thermodynamic-limit geometric law (orange). The
    predictions use the conserved $Q=9000$ and $M=2000$; no parameter is fitted
    to the displayed histogram.
  ],
)

To quantify temporal dependence, the code estimates the integrated
autocorrelation time of the $nu_A$ snapshot series by summing positive empirical
autocorrelations. Across runs,

$ tau_"int"=4.876 plus.minus 1.289 " snapshots", quad
  "ESS"=108.19 plus.minus 25.05 $

out of 1000 stored snapshots per run. These spreads are sample standard
deviations across eight runs, not confidence intervals. Particle values within
a snapshot are also constrained by fixed $Q$, so these diagnostics do not prove
that the TV discrepancy is mostly sampling noise. They show close finite-run
agreement with the exact law at the tested scale. The $5$-million-update burn-in
is an operational choice checked against the reservoir-energy traces, not a
rigorous mixing-time bound; the detailed-balance theorem, rather than this
finite run, establishes the limiting stationary law.

= Relation to Bose-Einstein statistics

The limiting marginal

$ P(m)=(1-exp[-beta epsilon])exp[-beta epsilon m] $

and mean

$ ⟨m⟩=1/(exp(beta epsilon)-1) $

have the same algebraic form as a single-energy bosonic occupancy law written
with $mu=0$. More generally, conventional notation gives
$r=exp[-beta(epsilon-mu)]$. Because this model has only one energy and conserves
$Q$, it cannot identify $T$ and $mu$ independently. Its relation
$r=exp[-beta epsilon]$ is therefore a convenient thermodynamic parametrization,
not a derived physical statement that the chemical potential vanishes. Bose's
and Einstein's work supplies the historical quantum-statistical setting [1, 2].

The present construction differs in interpretation: the containers are
identified with finite nonempty discrete particles and the quanta with
transferable list entries. The boundary of the result—single energy rather than
a spectrum, occupancy mathematics rather than quantum mechanics, and closed
equilibrium rather than formation or escape—is maintained throughout.

= Reproducibility

The simulations are deterministic given their pseudorandom seeds and are
implemented in the accompanying source files:

- `two_bath_reversible_exchange.cpp`: symmetric reversible exchange between two
  initially unequal reservoirs.

The reproducibility archive is the public repository
#link("https://github.com/matterasmachine/matterasmachine")[github.com/matterasmachine/matterasmachine].
The exact manuscript and source release is
#link("https://github.com/matterasmachine/matterasmachine/releases/tag/thermodynamic-exchange-v1.0")[`thermodynamic-exchange-v1.0`],
and its project folder is available
#link("https://github.com/matterasmachine/matterasmachine/tree/thermodynamic-exchange-v1.0/thermodynamic-exchange")[at that tagged revision].
No DOI has yet been assigned.

The simulation is not an independent proof of equilibrium: detailed balance
already supplies that proof. It validates the implementation, demonstrates
convergence from unequal reservoirs, and measures finite-run agreement with the
exact marginal. The reported run-to-run standard deviations and ESS diagnostics
are not confidence intervals or precision estimates of universal constants.

= Conclusion

The stated occupancy coarse-graining, single-current-instruction postulate, and
symmetric encounter-and-transfer kernel
produce a coherent ideal equilibrium model. Uniform fixed-energy
configurations have an exact finite marginal that approaches a geometric law.
Adopting $S=k log Omega$ and the thermodynamic definition of temperature maps
the counted multiplicity to the thermodynamic-limit geometric ratio
$r=exp[-epsilon/(k T)]$. A symmetric
one-quantum Markov process converges to
this equilibrium, while two-reservoir simulations show energy equalization and
vanishing late-time net flux.

The list ontology motivates the model but is not evidence that real particles
have this structure. Such evidence requires a discriminating empirical
prediction not shared by ordinary balls-in-boxes or zero-range models. The
mathematical result is modest but concrete:

#note[
Within the stated occupancy coarse-graining and exchange kernel, for discrete
particles that reversibly exchange conserved equal-energy quanta,
the counted configurations fix a geometric equilibrium parameter that can be
written in Bose-Einstein-shaped thermodynamic form. This conclusion is
conditional on both assumptions and does not establish a microscopic ontology.
]

= Outlook: open systems and a low-size penalty

The stationary law is a long-time limit, whereas a real source supplies only a
finite number $L$ of interactions. Fixed-$L$ random-walk endpoints have a
Gaussian-like tail $exp[-x^2/(2 L)]$, not the stationary exponential tail.
Finite formation may therefore yield a Gaussian-like high-energy cutoff; the
Sun's spectrum is one possible test of this distinction.

#figure(
  image("solar-short-wavelength-finite-walk-outlook.png", width: 100%),
  caption: [
    *Possible finite-interaction signature.* Short-wavelength (high-energy)
    solar luminosity compared with a fitted Planck wavelength law and a
    finite one-quantum walk starting at size one and absorbed at zero. The
    comparison is illustrative; a quantitative empirical test and a complete
    source model are left for future work.
  ],
)

The restriction $n>=1$ belongs only to the closed equilibrium model. In the
proposed full model, a size-one particle may lose its final instruction through
$1 arrow.r 0$ and disappear; zero denotes absence, not another particle size.
If surrounding matter supplies size-one particles within a dense region, that
left-boundary input can balance deaths locally. Outside the supplied region,
absorption breaks detailed balance and geometric equilibrium need not persist.

A separate absorbing random-walk model suggests a more specific possibility.
For an unbiased one-quantum walk with absorption at zero, the characteristic
lifetime from initial size $x$ scales as $x^2$. Under stationary production, if
the observed population at size $x$ is proportional to this lifetime, applying
that survival factor to the Bose-shaped occupancy term gives

$ N(x) prop x^2/(exp(x)-1). $

This black-body photon-number shape suggests a mode-free interpretation: closed
exchange supplies the denominator and open loss penalizes the smallest
particles. Application to black-body or solar radiation requires a separate
production and boundary model; it is not part of the present theorem.

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

[5] M. R. Evans and T. Hanney, "Nonequilibrium Statistical Mechanics of the
Zero-Range Process and Related Models," _Journal of Physics A: Mathematical and
General_ *38* (2005), R195-R240.
#link("https://doi.org/10.1088/0305-4470/38/19/R01")[doi:10.1088/0305-4470/38/19/R01].
