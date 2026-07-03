#set page(
  paper: "a4",
  margin: (top: 21mm, bottom: 22mm, left: 24mm, right: 24mm),
  numbering: "1",
  number-align: center + bottom,
)
#set text(font: "New Computer Modern", size: 10pt, lang: "en")
#set par(justify: true, leading: 0.58em)
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
particles. A particle is represented only by a nonempty finite list of quanta.
Each particle has one nonexchangeable baseline quantum and a nonnegative number
of exchangeable quanta, each carrying energy $epsilon$. An elementary event
transfers exactly one exchangeable quantum from one particle to another, so the
total exchangeable energy is conserved. For $M$ particles and $Q$ exchangeable
quanta, the number of occupancy configurations is
$binom(Q+M-1,Q)$. The uniform microcanonical measure therefore has an exact
finite-system marginal distribution and, in the thermodynamic limit at fixed
$nu=Q/M$, a geometric marginal
$P(m)=(1-r)r^m$ with $r=nu/(1+nu)$. Defining entropy by
$S=k log Omega$ and temperature by $1/T=(partial S)/(partial E)$ gives
$r=exp[-epsilon/(k T)]$ and
$⟨m⟩=1/[exp(epsilon/(k T))-1]$. Thus the exponential thermal
parameter is obtained from state counting rather than inserted as a change of
variables. A reversible one-quantum Markov process is shown to have the uniform
microcanonical measure as its unique stationary distribution. Simulations of
two initially unequal reservoirs show energy equalization, vanishing late-time
net flux, and approximately geometric particle-size statistics. In one reported
simulation, a directional extension with six taxicab instructions and
perpendicular-only exchange shows approximate agreement with the same
equilibrium statistics while relaxing more slowly; no stationary-law theorem is
claimed for that asymmetric process. The result is a minimal
thermodynamics of a fixed-energy exchange ensemble, not a derivation of quantum
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

The note uses the language of particles as lists because that is the intended
interpretation. Mathematically, however, the same counting is the familiar
distribution of indistinguishable quanta among distinguishable containers. It
is closely related to standard Bose-Einstein occupancy counting. The claim is
therefore not that the combinatorial formula is new. The useful point is that a
very small set of explicit list-exchange rules realizes it dynamically and
gives temperature an operational meaning within that model.

Several topics are intentionally excluded. There is no spatial escape in the
equilibrium derivation, no cosmological loss or "tired light," no creation of
matter, no pressure-volume law, and no claim that the six-direction extension
removes all taxicab anisotropy. These belong to separate models and should not
be used to justify the equilibrium result proved here.

= Discrete particles and conserved exchange energy

Consider $M>=2$ distinguishable particles. Particle $i$ has total list length

$ n_i=1+m_i, quad m_i in {0,1,2,dots}. $

The baseline instruction ensures that a particle always exists: $n_i>=1$.
Only the $m_i$ excess instructions participate in the present energy accounting.
Each excess instruction carries the same energy $epsilon>0$. Hence

$ E_i=epsilon m_i, quad
  E=sum_(i=1)^M E_i=epsilon Q, quad
  Q=sum_(i=1)^M m_i. $

An elementary exchange transfers one excess instruction:

$ (m_i,m_j) arrow.r (m_i-1,m_j+1), quad m_i>=1. $

The reverse event is also allowed. Every event conserves $Q$ and therefore $E$.
No instruction is created or destroyed in this closed model.

The baseline is a convention that keeps the particle ontology stable. If one
wishes to assign energy $epsilon$ to it as well, every particle receives the
same additive energy offset. Such an offset changes the total energy by
$M epsilon$ but does not affect exchange probabilities, entropy differences,
temperature, or the distribution of $m_i$.

= Exact finite-system state counting

== Number of configurations

A microconfiguration at the occupancy level is an ordered $M$-tuple

$ (m_1,dots,m_M), quad m_i>=0, quad sum_i m_i=Q. $

The number of such weak compositions is the stars-and-bars count

$ Omega(Q,M)=binom(Q+M-1,Q)=binom(Q+M-1,M-1). $

The microcanonical assumption is that all these occupancy configurations have
equal stationary probability. Section 6 supplies an explicit Markov process for
which this is not merely assumed but follows from detailed balance and
ergodicity.

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

where $k$ fixes the temperature unit. Using Stirling's approximation at large
$Q$ and $M$ gives

$ S/k approx
  (Q+M)log(Q+M)-Q log Q-M log M. $

In terms of $nu=Q/M$,

$ S approx k M [(1+nu)log(1+nu)-nu log nu]. $

Temperature is defined thermodynamically by

$ 1/T=(partial S)/(partial E)_M. $

Applying this definition to the Stirling-limit entropy, and using
$E=epsilon Q$, gives in the thermodynamic limit

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
$1/T=partial S/partial E$.
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

Operationally, two bodies have the same temperature when their late-time mean
energy flux vanishes. This is stronger than identifying temperature with an
interaction frequency: changing the event rate changes how quickly equilibrium
is reached, whereas changing $Q/M$ changes which equilibrium is reached.

== First law in the closed exchange model

Every transfer removes one quantum from one particle and gives it to another.
Therefore

$ Delta E_A+Delta E_B=0. $

There is heat exchange but no work term in the present model. Its first-law
content is simply conservation of exchange energy.

== Second law as a typicality statement

Starting far from equilibrium, overwhelmingly more configurations correspond to
energy divisions near the maximum of $S_A+S_B$ than to extreme divisions. A
reversible stochastic process therefore moves toward the high-multiplicity
region with high probability. Microscopic trajectories can fluctuate away from
it; the statistical claim is that the equilibrium macrostate dominates for
large systems.

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

If physical exchange rules violate these conditions, a different stationary
law may result.

= Two-reservoir numerical experiment

== Nondirectional control model

The implementation `two_bath_reversible_exchange.cpp` used two reservoirs with
$1000$ particles each. Reservoir $A$ began with mean excess occupancy $8$ and
reservoir $B$ with mean excess occupancy $1$. Thus the conserved global mean was

$ nu_"global"=(8+1)/2=4.5. $

After $50$ million attempted transfers, representative late-time values were

#block(breakable: false)[
#align(center)[
#table(
  columns: (1.6fr, 1fr, 1fr, 1.2fr),
  align: (left, right, right, right),
  [stage], [$nu_A$], [$nu_B$], [net cross-flux],
  [initial], [8.000], [1.000], [positive],
  [late representative state], [4.477], [4.523], [$-2.0 times 10^(-5)$],
  [equilibrium target], [4.500], [4.500], [0],
)
]
]

The equilibrium parameters predicted from the conserved global mean are

$ r=4.5/5.5=0.818182, quad
  beta epsilon=log(1+1/4.5)=0.200671. $

The reservoir means fluctuate around $4.5$ rather than remaining exactly equal
at every snapshot, as expected for finite systems.

== Directional particles and perpendicular exchange

For a directional extension, every list entry belongs to

$ cal(D)={R,L,U,D,F,B}. $

Each particle selects an active instruction uniformly from its list. Two active
instructions are compatible only when their coordinate axes are perpendicular.
For an isotropic six-direction mixture, the compatible fraction is

$ P_"perp"=4/6=2/3. $

When a pair is compatible, either particle is chosen as donor with probability
$1/2$; if the selected donor has excess occupancy, its active instruction is
transferred to the receiver. The total number of instructions is conserved.

The implementation `two_bath_perpendicular_exchange.cpp` used $2000$ particles
per reservoir, the same initial means $8$ and $1$, a $20%$ probability of a
cross-reservoir encounter, and $200$ million attempted interactions. It measured

#block(breakable: false)[
#align(center)[
#table(
  columns: (2fr, 1fr, 1fr),
  align: (left, right, right),
  [quantity], [perpendicular only], [all directions],
  [late $nu_A$], [4.465], [4.693],
  [late $nu_B$], [4.535], [4.308],
  [successful transfers per cross attempt], [0.546], [0.818],
  [late net flux per cross attempt], [$4.1 times 10^(-5)$], [$-1.26 times 10^(-4)$],
  [geometric TV distance, $A$], [0.039], [0.049],
  [geometric TV distance, $B$], [0.035], [0.033],
)
]
]

The unequal late values in a single snapshot are finite-size fluctuations. The
time series oscillates around the common target $4.5$, and the late net flux
oscillates around zero.

The ratio of transfer frequencies is

$ 0.546/0.818 approx 0.667, $

matching the expected perpendicular compatibility fraction $2/3$. The
perpendicular rule therefore changes the relaxation rate but does not appear to
create the thermal equilibrium law. This control is important: the geometric
equilibrium is attributable to reversible conserved exchange, while
perpendicularity remains a separate kinematic restriction.

== Why the simulated TV distance is not zero

There are three sources of visible discrepancy from a perfect geometric curve:

- the exact finite-system marginal is not exactly geometric;
- a histogram from a finite snapshot has sampling noise; and
- selecting active instructions proportionally to their multiplicities changes
  microscopic transition weights in the directional implementation, so its
  occupancy projection is not identical to the ideal symmetric-edge chain.

The numerical result should therefore be described as approximate agreement in
the reported simulation, not as an exact computational proof or evidence of a
proved directional stationary law.

= Relation to Bose-Einstein statistics

The limiting marginal

$ P(m)=(1-exp[-beta epsilon])exp[-beta epsilon m] $

and mean

$ ⟨m⟩=1/(exp(beta epsilon)-1) $

are the standard single-energy bosonic occupancy formulas at zero chemical
potential. Bose's original radiation counting and Einstein's extension to an
ideal gas established the historical quantum-statistical setting for these
expressions [1, 2].

The present construction differs in interpretation. The distinguishable
containers are taken to be discrete particles represented by lists, and the
quanta are transferable list entries. This interpretation is an additional
physical hypothesis; the combinatorics alone does not establish that actual
particles have this structure.

Three distinctions prevent overstatement:

+ *Single energy versus a spectrum.* This note assumes one quantum energy
  $epsilon$. A Planck spectrum requires a family of energies and a density of
  states.
+ *Occupancy mathematics versus quantum mechanics.* The geometric law does not
  derive wave functions, commutation relations, indistinguishability from first
  principles, or bosonic exchange symmetry.
+ *Equilibrium versus formation and escape.* The closed microcanonical model
  does not describe photons leaving a source region. Open-system escape is a
  different stochastic problem.

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
- the final directional exchange law of a matter-as-machine theory;
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

- `two_bath_reversible_exchange.cpp`: symmetric nondirectional exchange;
- `two_bath_perpendicular_exchange.cpp`: directional and all-direction controls;
- `test_geometric_robustness.cpp`: geometric-fit robustness in the separate open
  escape model; and
- `predict_endpoints_from_escape_chain.cpp`: a coarse-grained prediction test
  for that open model.

Only the first two are evidence for the closed equilibrium claims of this note.
The latter two are listed to make the separation from the open formation model
explicit.

The reproducibility archive is the public repository
#link("https://github.com/matterasmachine/matterasmachine")[github.com/matterasmachine/matterasmachine].
The simulation code used for the reported runs is fixed at commit
#link("https://github.com/matterasmachine/matterasmachine/commit/6cf453728bbf76d8ad3ef2f1c5755c42be30528b")[`6cf453728bbf76d8ad3ef2f1c5755c42be30528b`].
The corresponding project folder can be viewed directly
#link("https://github.com/matterasmachine/matterasmachine/tree/6cf453728bbf76d8ad3ef2f1c5755c42be30528b/thermodynamic-exchange")[at this permanent revision].
Later manuscript edits may continue to cite this commit as long as the simulation
code and reported numerical results remain unchanged.

For each reported equilibrium run, one should retain the complete time series,
repeat several independent seeds, and report confidence intervals rather than a
single late snapshot. The present numbers are validation runs, not precision
estimates of universal constants.

= Conclusion

A minimal reversible exchange process among nonempty discrete particles is
enough to produce a coherent ideal thermodynamics. Uniform fixed-energy
configurations have an exact finite marginal that approaches a geometric law.
The logarithm of their multiplicity supplies entropy; differentiating entropy
with respect to energy supplies temperature; and the resulting
thermodynamic-limit geometric ratio is $r=exp[-epsilon/(k T)]$. A symmetric
one-quantum Markov process converges to
this equilibrium, while two-reservoir simulations show energy equalization and
vanishing late-time net flux.

In the reported run, the six-direction perpendicular-exchange extension showed
approximate agreement with the qualitative equilibrium statistics and reduced
the interaction rate by the expected factor $2/3$. Because its transition
weights are state-dependent and asymmetric, this observation is numerical only;
it does not establish that the directional process has the same stationary law.
It supports treating perpendicularity as a possible kinematic restriction, but
not as the proved origin of the thermal law.

The main conceptual result is therefore modest but concrete:

#note[
For discrete particles that reversibly exchange conserved equal-energy quanta,
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

= Appendix B: a finite-difference temperature

Before taking derivatives, define a discrete inverse temperature from the
entropy gained when one quantum is added. The exact binomial ratio is
$Omega(Q+1,M)/Omega(Q,M)=(Q+M)/(Q+1)$, and hence

$ (Delta S)/epsilon
  =(k/epsilon)log((Q+M)/(Q+1))
  arrow.r 1/T=(k/epsilon)log((Q+M)/Q). $

The arrow denotes the large-$Q,M$ limit. This formula makes clear that
temperature measures the multiplicative increase in accessible configurations
per added energy quantum.
