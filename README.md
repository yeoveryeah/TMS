# Bayesian Inference for Two-State Markov Switching Model



We took burn-in samples of 1,000 and samples of 10,000 in emprical study. 

### Step 1 Hidden State Values Simulation -  Viterbi Algorithm

As indicated by the name of HMM, the state values are latent. We will apply the Viterbi algorithm to find the most likely state values given observations $y_t$.

Mathematically, the Viterbi algorithm is an optimization problem over posterior estimation. 

$$
\vec{S_T} = \arg\max_{\vec{S_T}} \ \Pr(\vec{S_T} \mid \vec{y_T})
$$

Let $\delta_t(k)$ be the probability of arriving at state k at time t assuming that the most likely path was taken.

$$
\delta_t(k) \triangleq \max_{\vec{S_{t-1}}} \Pr(\vec{S_{t-1}}, S_t = k \mid \vec{y_T})
$$
Intuitively, $\delta_t(k)$ defines the most probable path to state j at step t by taking the most probable path to state i at t-1, followed by a transition from i to k. 

Let $a_t(j)$ denote the most likely previous state on the most likely path to j at step t:

$$
a_t(j)=\max_{i} \delta_{t-1}(i) \cdot p_{ik}\cdot \psi_t(k)
$$
Where $\psi_t(k) = \Pr(y_t\mid S_t=k)$ is the local evidence at step t.

In Gibbs sampler, it will initialize $\delta_1(k) = f_y(y_1\mid S_1=k)$ and terminating with the most probable final state $S_T^*=\arg\max_i \delta_T(i)$, the most probable sequence of states is estimated backwards.

$$
S_t^*\mid (S_{t+1}^*=j) = a_{t+1}(j)
$$

Finally, we'll get $(S_1^*,\dots, S_T^*)$ estimation to be used in later steps of the Gibbs Sampler.

### Step 2: Bayesian Generator for $\sigma_1^2$ for each state

To generate $\sigma^2$'s such that $\sigma_1^2 < \sigma_2^2$, we proposed a scalar parameter $\gamma > 0$ and define $\sigma_{2}^2 = (1+ \gamma)\sigma_2^2$. Note that the subscript of $\sigma^2$ here represent the state 1 and 2 respectively, rather than the time. 

The Bayesian framework^[Proof will be drafted in the Appendix] can be documented as follows.

$$
\begin{aligned}
\sigma_1^2 &\sim IG(\frac{1}{2},\frac{1}{2})
&(\text{Prior})\\
Y_{1t} &= \frac{y_t}{\sqrt { (1+\mathbb{I}\{S_t = 2\}\gamma)}}\sim N(0,\sigma_1^2)\\
\sigma_1^2 \mid \{Y_{1t}\}_{t=1,...,T}&\sim IG(\frac{1+T}{2}, \frac{1+\sum_{t=1}^{T}Y_{1t}^2}{2})
&(\text{Posterior})\\
\end{aligned}
$$

### Step 3: Bayesian Generator for $\sigma_2^2$ for each state

Let $\bar{\gamma} = 1+\gamma$, $\sigma_2^2 = (1+\gamma)\sigma_1^2=\bar{\gamma}\sigma_1^2$.

$N_2 = \{t: S_t =2, t=1,\dots,T\}, T_2 = \text{sum of elements in } N_2$

The Bayesian framework^[Proof will be drafted in the Appendix] can be documented as follows.

$$
\begin{aligned}
\bar{\gamma}&\sim IG(\frac{1}{2},\frac{1}{2})\cdot\mathbb{I}\{{\bar{\gamma}>1}\}
&(\text{Prior})\\
Y_{2t} &= \frac{y_t}{\sqrt{\sigma_1^2}}, t\in T_2 \sim N(0,\bar{\gamma})\\
\bar{\gamma} \mid \{Y_{2t}\}_{t\in T_2}, \theta_{-2}
&\sim IG(\frac{1+T_2}{2}, \frac{1+\sum_{t=1}^{N_2}Y_{2t}^2}{2}) \cdot\mathbb{I}\{\bar{\gamma} >1\}
&(\text{Posterior})\\
\end{aligned}
$$

Then, at each iteration, $\sigma_2^2 = \sigma_1^2\cdot\bar{\gamma}$ with updated $\sigma_1^2$ and $\bar{\gamma}$ at current iteration.

###  Step 4 Draw $p \mid \theta_{-3}, \vec{S_T}$

Given the data $\vec{S_T}$, we can get the number of transitions from state i to state j, i.e. $n_{ij}, i,j =1,2$. Then the likelihood function conditioned on the initial state is given by
$$
L(p) =\prod_{\forall i,j} p_{ij}^{n_{ij}}
$$

From the likelihood, it's clear that the Beta family of distributions is a conjugate prior for each of the transition probabilities. We choose the prior $p_{12}, p_{21} \stackrel{iid}{\sim} Beta(1,1)$, equivalently $U(0,1)$. The Bayesian framework^[Proof will be drafted in the Appendix] can be documented as follows.

$$
\begin{aligned}
\pi(p_{12}, p_{21}) &\propto Beta(1,1) \cdot Beta(1,1) &\text{(Prior)}\\
p_{12} \mid \vec{S_T} &\sim Beta(1+n_{12},1+n_{11}) &\text{(Posterior)}\\
p_{21} \mid \vec{S_T} &\sim Beta(1+n_{21},1+n_{22})
&\text{(Posterior)}\\
p_{12} \mid \vec{S_T} &\perp p_{21} \mid \vec{S_T} \\
\end{aligned}
$$


## Variance Ratio Test

At each Gibbs run, one more step to act is the VR calculation. The objective is to simulate from the posterior distribution of the variance of mixture Gaussian distribution given its observed values. Based on the observed series and simulated variance series, VR statistics can be obtained. After enough iterations, we could simulate the posterior sampling distribution of VR values to make inference in terms of mean reversion. However, as this step is not considered to be parameter estimation, but it will proceed at each Gibbs sweep following Step 1 to 4. 
Define and calculate q period standardized return $r_{q,t} = \tilde{y_t}- \tilde{y_{Q,t}}$. Then, the Variance Ratio(VR) is defined as following.
$$
VR(q) = \frac{Var[r_{Q,t}]}{Q\cdot Var[r_{1,t}]}
$$

The reasoning behind the test of random walk is: If the observation series follows a random walk, then $r_{1,t}$ is serially random and the Q-period return,$r_{Q,t}$, is simply the accumulation of Q successive $r_{1,t}$. As a result, the VR will be unity for all periods $Q$. 

The two VR statistics of interest and to convey the VR test is given by:

1. Standardized observations: $\{y_t^* = y_t/\sigma_t, t=1,\dots,T\}$. The $\sigma_t$ is from the last iteration of Gibbs. Define and calculate Q period standardized return $r_{Q,t} = \tilde{y_t}- \tilde{y_{Q,t}}$. The VR based on $r_{Q,t}$ is denoted by $VR(Q)$

2. Randomized returns: Generate the randomize the return from $z_t \sim N(0,1)$, and get the randomized returns $r_{Q,t}^* = z_t\cdot \sigma_t$ in which way it will keep the information contained in $\sigma_t$. Calculate the VR statistics based on $\{r^*_{Q,t}, t=1,\dots,T\}$, denoted by $VR^*(Q)$.

The reason why the randomized returns are generated in this way is to maintain the information contained in the variance series, especially dynamics in the state space. In comparing $VR(Q)$ and $VR^*(Q)$, we're actually comparing the VR test statistics for standardized historical returns and the test statistic under the null hypothesis

After M Gibbs sampler iterations, it will produce the posterior distribution of the VR for standardized historical returns, $VR(Q)$, and the empirical distribution of the VR under the null of no mean reversion, $VR^*(Q)$. Then the p-values can be calculated as:

$$
P(H_0) = \frac{\#(VR^*(Q) < VR(Q))}{M}
$$

Then conclusion can be drawn based on the p-value. We'll inference at the significant level of 0.05. At a p-value < 0.05, we will reject the null hypothesis of no mean reversion and conclude mean-reversion. 

 
