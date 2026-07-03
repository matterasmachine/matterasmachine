<template>
  <main class="escape-page">
    <header class="hero">
      <div class="eyebrow">DIRECTIONAL MATTER EXCHANGE · SPATIAL ESCAPE</div>
      <h1>Formation ends at the source boundary.</h1>
      <p>
        Particles begin inside a sphere of sources. Each tick executes one of six
        directional instructions. Only perpendicular active instructions can exchange. Formation ends and the
        endpoint is recorded as soon as the particle leaves the source area.
      </p>
    </header>

    <section class="experiment">
      <div class="canvas-wrap">
        <canvas ref="canvas" width="1560" height="1050"></canvas>
      </div>

      <aside class="controls">
        <div class="control-heading">
          <span>Live experiment</span>
          <button type="button" @click="running = !running">{{ running ? 'Pause' : 'Run' }}</button>
        </div>

        <label>
          <span>Minimum escaped energy <b>n ≥ {{ minimumEnergy }}</b></span>
          <input v-model.number="minimumEnergy" type="range" min="1" max="20" step="1" @input="rebuildFilteredStatistics" />
        </label>

        <label>
          <span>Number of sources <b>{{ sourceCount }}</b></span>
          <input v-model.number="sourceCount" type="range" min="30" max="600" step="10" @input="restartSources" />
        </label>

        <label>
          <span>Source area <b>{{ sourceArea.toFixed(2) }}</b></span>
          <input v-model.number="sourceRadius" type="range" min="0.5" max="5" step="0.1" @input="restartSources" />
        </label>

        <label>
          <span>Interaction probability scale <b>{{ interactionScale.toFixed(2) }}</b></span>
          <input v-model.number="interactionScale" type="range" min="0.03" max="0.9" step="0.01" @input="restart" />
        </label>

        <label>
          <span>Reset probability / instruction / tick <b>{{ resetProbability.toFixed(4) }}</b></span>
          <input v-model.number="resetProbability" type="range" min="0" max="0.005" step="0.0001" @input="restart" />
        </label>

        <label>
          <span>Visible particles <b>{{ particleCount }}</b></span>
          <input v-model.number="particleCount" type="range" min="30" max="240" step="10" @input="syncParticles" />
        </label>

        <label>
          <span>Animation speed <b>{{ speed.toFixed(1) }}×</b></span>
          <input v-model.number="speed" type="range" min="0.3" max="3" step="0.1" />
        </label>

        <label class="death-toggle">
          <input v-model="allowDeath" type="checkbox" @change="restart" />
          <span>
            <b>Allow particle death at n = 0</b>
            <small>Loss at n = 1 removes the particle.</small>
          </span>
        </label>

        <button class="restart" type="button" @click="restart">Restart statistics</button>
        <button class="restart" type="button" :disabled="!escapeRecords.length" @click="referenceMeanSize = allMeanSize">
          Save current size as baseline
        </button>

        <div class="facts">
          <div><span>All escaped particles</span><b>{{ allEscapes.toLocaleString() }}</b></div>
          <div><span>Average photon size (all)</span><b>{{ allMeanSize.toFixed(2) }}</b></div>
          <div><span>Saved baseline size</span><b>{{ referenceMeanSize ? referenceMeanSize.toFixed(2) : 'not set' }}</b></div>
          <div><span>Size / baseline</span><b>{{ sizeRatio.toFixed(3) }}×</b></div>
          <div><span>Included escapes</span><b>{{ completions.toLocaleString() }}</b></div>
          <div><span>Particles lost at n = 0</span><b>{{ deaths.toLocaleString() }}</b></div>
          <div><span>Instructions removed by reset</span><b>{{ resetLosses.toLocaleString() }}</b></div>
          <div><span>Mean escape time</span><b>{{ meanEscapeTime.toFixed(1) }} ticks</b></div>
          <div><span>Mean final size</span><b>{{ meanEndpoint.toFixed(2) }}</b></div>
          <div><span>Speed samples (current filter)</span><b>{{ exitSpeeds.length.toLocaleString() }}</b></div>
          <div><span>Mean exit speed</span><b>{{ meanExitSpeed.toFixed(3) }}</b></div>
          <div><span>Most probable speed</span><b>{{ speedMode.center.toFixed(3) }}</b></div>
          <div><span>Modal speed bin</span><b>{{ speedMode.low.toFixed(3) }}-{{ speedMode.high.toFixed(3) }}</b></div>
          <div><span>Median exit speed</span><b>{{ medianExitSpeed.toFixed(3) }}</b></div>
          <div><span>Speed standard deviation</span><b>{{ exitSpeedDeviation.toFixed(3) }}</b></div>
          <div><span>Central 80% of speeds</span><b>{{ speedPercentile10.toFixed(3) }}-{{ speedPercentile90.toFixed(3) }}</b></div>
          <div><span>Speed drift (second-first half)</span><b>{{ speedDrift >= 0 ? '+' : '' }}{{ speedDrift.toFixed(3) }}</b></div>
          <div><span>Mean exit angle</span><b>{{ meanExitAngle.toFixed(1) }}°</b></div>
          <div><span>Escape decay gamma</span><b>{{ exponentialFit.gamma.toFixed(4) }}/tick</b></div>
          <div><span>Exponential-fit R²</span><b>{{ exponentialFit.rSquared.toFixed(3) }}</b></div>
          <div><span>Largest escaped size</span><b>{{ largestEndpoint }}</b></div>
          <div><span>Encounter probability</span><b>{{ encounterProbability.toFixed(3) }}</b></div>
          <div><span>Travel radius</span><b>{{ sourceRadius.toFixed(1) }}</b></div>
          <div><span>Geometric TV error</span><b>{{ geometricError.toFixed(3) }}</b></div>
        </div>
      </aside>
    </section>

    <section class="explanation">
      <article>
        <span>01</span>
        <h2>Perpendicular exchange</h2>
        <p>An incoming instruction transfers only when it is perpendicular to the particle's active instruction. Composition therefore changes future compatibility.</p>
      </article>
      <article>
        <span>02</span>
        <h2>Inside only</h2>
        <p>Instruction exchanges occur only inside the source area. Nothing outside that area contributes to the statistics.</p>
      </article>
      <article>
        <span>03</span>
        <h2>Source-boundary escape</h2>
        <p>Crossing the source boundary immediately records the particle's size and starts a new particle at the center.</p>
      </article>
      <article class="caution">
        <span>RESULT</span>
        <h2>Approximate, not exact</h2>
        <p>The late survival tail is close to exponential and endpoints are close to geometric, but the complete spatial process is not an exact Planck derivation.</p>
      </article>
    </section>
  </main>
</template>

<script>
const DIRECTIONS = [
  [1, 0, 0], [-1, 0, 0],
  [0, 1, 0], [0, -1, 0],
  [0, 0, 1], [0, 0, -1],
];
const COLORS = ['#138aa3', '#3f71d8', '#8a64d6', '#18a77b', '#d55278'];
const STEP = 0.025;

export default {
  name: 'DirectionalSourceEscape',
  data() {
    return {
      sourceCount: 230,
      sourceRadius: 1,
      interactionScale: 0.35,
      resetProbability: 0,
      minimumEnergy: 1,
      particleCount: 110,
      speed: 1,
      running: true,
      allowDeath: false,
      particles: [],
      sourcePoints: [],
      endpoints: [0, 0],
      escapeTimes: [],
      exitSpeeds: [],
      exitAngles: [],
      escapeRecords: [],
      completions: 0,
      allEscapes: 0,
      deaths: 0,
      resetLosses: 0,
      totalEndpoint: 0,
      totalInteractions: 0,
      referenceMeanSize: 0,
      animationFrame: null,
      previousTime: 0,
      accumulator: 0,
    };
  },
  computed: {
    allMeanSize() {
      if (!this.escapeRecords.length) return 0;
      return this.escapeRecords.reduce((sum, record) => sum + record.size, 0) / this.escapeRecords.length;
    },
    sizeRatio() {
      return this.referenceMeanSize ? this.allMeanSize / this.referenceMeanSize : 0;
    },
    sourceArea() {
      return Math.PI * this.sourceRadius * this.sourceRadius;
    },
    encounterProbability() {
      return Math.min(0.95, this.interactionScale * (this.sourceCount / 230));
    },
    meanEscapeTime() {
      if (!this.escapeTimes.length) return 0;
      return this.escapeTimes.reduce((sum, value) => sum + value, 0) / this.escapeTimes.length;
    },
    meanEndpoint() {
      return this.completions ? this.totalEndpoint / this.completions : this.minimumEnergy;
    },
    meanExitSpeed() {
      if (!this.exitSpeeds.length) return 0;
      return this.exitSpeeds.reduce((sum, value) => sum + value, 0) / this.exitSpeeds.length;
    },
    sortedExitSpeeds() {
      return this.exitSpeeds.slice().sort((a, b) => a - b);
    },
    medianExitSpeed() {
      return this.speedQuantile(0.5);
    },
    speedPercentile10() {
      return this.speedQuantile(0.1);
    },
    speedPercentile90() {
      return this.speedQuantile(0.9);
    },
    exitSpeedDeviation() {
      if (!this.exitSpeeds.length) return 0;
      const variance = this.exitSpeeds.reduce((sum, value) =>
        sum + (value - this.meanExitSpeed) ** 2, 0) / this.exitSpeeds.length;
      return Math.sqrt(variance);
    },
    speedDrift() {
      if (this.exitSpeeds.length < 20) return 0;
      const middle = Math.floor(this.exitSpeeds.length / 2);
      const first = this.exitSpeeds.slice(0, middle);
      const second = this.exitSpeeds.slice(middle);
      const firstMean = first.reduce((sum, value) => sum + value, 0) / first.length;
      const secondMean = second.reduce((sum, value) => sum + value, 0) / second.length;
      return secondMean - firstMean;
    },
    exponentialFit() {
      const times = this.escapeTimes.slice().sort((a, b) => a - b);
      if (times.length < 20) return { gamma: 0, rSquared: 0 };
      const points = [];
      const start = Math.floor(times.length * 0.1);
      const end = Math.max(start + 2, Math.floor(times.length * 0.9));
      for (let index = start; index < end; index += 1) {
        points.push({ x: times[index], y: Math.log((times.length - index) / times.length) });
      }
      const meanX = points.reduce((sum, point) => sum + point.x, 0) / points.length;
      const meanY = points.reduce((sum, point) => sum + point.y, 0) / points.length;
      let covariance = 0;
      let varianceX = 0;
      let varianceY = 0;
      points.forEach((point) => {
        covariance += (point.x - meanX) * (point.y - meanY);
        varianceX += (point.x - meanX) ** 2;
        varianceY += (point.y - meanY) ** 2;
      });
      const slope = varianceX ? covariance / varianceX : 0;
      const rSquared = varianceX && varianceY ? covariance ** 2 / (varianceX * varianceY) : 0;
      return { gamma: Math.max(0, -slope), rSquared };
    },
    speedMode() {
      const bins = 16;
      const counts = Array(bins).fill(0);
      this.exitSpeeds.forEach((value) => {
        const bin = Math.max(0, Math.min(bins - 1, Math.floor(value * bins)));
        counts[bin] += 1;
      });
      const index = counts.indexOf(Math.max(...counts));
      const low = index / bins;
      const high = (index + 1) / bins;
      return { low, high, center: (low + high) / 2, count: counts[index] };
    },
    meanExitAngle() {
      if (!this.exitAngles.length) return 0;
      return this.exitAngles.reduce((sum, value) => sum + value, 0) / this.exitAngles.length;
    },
    fittedR() {
      const excessMean = Math.max(0, this.meanEndpoint - this.minimumEnergy);
      return Math.max(0, Math.min(0.999, excessMean / (excessMean + 1)));
    },
    largestEndpoint() {
      return this.completions ? this.endpoints.length - 1 : 0;
    },
    geometricError() {
      if (!this.completions) return 0;
      let difference = 0;
      for (let n = this.minimumEnergy; n <= this.largestEndpoint; n += 1) {
        const observed = (this.endpoints[n] || 0) / this.completions;
        const expected = (1 - this.fittedR) * Math.pow(this.fittedR, n - this.minimumEnergy);
        difference += Math.abs(observed - expected);
      }
      difference += Math.pow(this.fittedR, this.largestEndpoint - this.minimumEnergy + 1);
      return difference / 2;
    },
  },
  mounted() {
    this.makeSourcePoints();
    this.syncParticles();
    this.animationFrame = requestAnimationFrame(this.animate);
  },
  beforeDestroy() {
    cancelAnimationFrame(this.animationFrame);
  },
  methods: {
    speedQuantile(probability) {
      const values = this.sortedExitSpeeds;
      if (!values.length) return 0;
      const position = (values.length - 1) * probability;
      const lower = Math.floor(position);
      const fraction = position - lower;
      return values[lower] + (values[Math.min(lower + 1, values.length - 1)] - values[lower]) * fraction;
    },
    makeSourcePoints() {
      this.sourcePoints = [];
      for (let i = 0; i < this.sourceCount; i += 1) {
        const angle = Math.random() * Math.PI * 2;
        const radius = Math.sqrt(Math.random());
        this.sourcePoints.push([Math.cos(angle) * radius, Math.sin(angle) * radius]);
      }
    },
    randomDirection() {
      return DIRECTIONS[Math.floor(Math.random() * DIRECTIONS.length)].slice();
    },
    randomSource() {
      let point = [2, 2, 2];
      while (point[0] ** 2 + point[1] ** 2 + point[2] ** 2 > 1) {
        point = [Math.random() * 2 - 1, Math.random() * 2 - 1, Math.random() * 2 - 1];
      }
      return point.map(value => value * this.sourceRadius);
    },
    quantize(vector) {
      let axis = 0;
      if (Math.abs(vector[1]) > Math.abs(vector[axis])) axis = 1;
      if (Math.abs(vector[2]) > Math.abs(vector[axis])) axis = 2;
      const result = [0, 0, 0];
      result[axis] = vector[axis] >= 0 ? 1 : -1;
      return result;
    },
    perpendicular(first, second) {
      return first[0] * second[0] + first[1] * second[1] + first[2] * second[2] === 0;
    },
    newParticle(index) {
      return {
        position: [0, 0, 0],
        instructions: [this.randomDirection()],
        age: 0,
        interactions: 0,
        color: COLORS[index % COLORS.length],
        trail: [[0, 0]],
      };
    },
    syncParticles() {
      while (this.particles.length < this.particleCount) {
        this.particles.push(this.newParticle(this.particles.length));
      }
      if (this.particles.length > this.particleCount) this.particles.splice(this.particleCount);
    },
    restartSources() {
      this.makeSourcePoints();
      this.restart();
    },
    restart() {
      this.endpoints = [0, 0];
      this.escapeTimes = [];
      this.exitSpeeds = [];
      this.exitAngles = [];
      this.escapeRecords = [];
      this.completions = 0;
      this.allEscapes = 0;
      this.deaths = 0;
      this.resetLosses = 0;
      this.totalEndpoint = 0;
      this.totalInteractions = 0;
      this.particles = [];
      this.syncParticles();
    },
    radius(position) {
      return Math.sqrt(position[0] ** 2 + position[1] ** 2 + position[2] ** 2);
    },
    recordEscape(particle, index) {
      const size = particle.instructions.length;
      this.allEscapes += 1;
      const net = particle.instructions.reduce((sum, direction) => [
        sum[0] + direction[0],
        sum[1] + direction[1],
        sum[2] + direction[2],
      ], [0, 0, 0]);
      const netLength = Math.sqrt(net[0] ** 2 + net[1] ** 2 + net[2] ** 2);
      const positionLength = this.radius(particle.position);
      const exitSpeed = netLength / size;
      let exitAngle = 90;
      if (netLength > 0 && positionLength > 0) {
        const cosine = Math.max(-1, Math.min(1,
          (net[0] * particle.position[0] + net[1] * particle.position[1] + net[2] * particle.position[2])
          / (netLength * positionLength)));
        exitAngle = Math.acos(cosine) * 180 / Math.PI;
      }
      this.escapeRecords.push({ size, age: particle.age, speed: exitSpeed, angle: exitAngle,
        interactions: particle.interactions });
      if (this.escapeRecords.length > 10000) this.escapeRecords.splice(0, this.escapeRecords.length - 10000);
      if (size >= this.minimumEnergy) this.addFilteredRecord(this.escapeRecords[this.escapeRecords.length - 1]);
      this.$set(this.particles, index, this.newParticle(index));
    },
    addFilteredRecord(record) {
      this.completions += 1;
      this.totalEndpoint += record.size;
      this.totalInteractions += record.interactions;
      while (this.endpoints.length <= record.size) this.endpoints.push(0);
      this.$set(this.endpoints, record.size, this.endpoints[record.size] + 1);
      this.escapeTimes.push(record.age);
      this.exitSpeeds.push(record.speed);
      this.exitAngles.push(record.angle);
    },
    rebuildFilteredStatistics() {
      this.endpoints = [0, 0];
      this.escapeTimes = [];
      this.exitSpeeds = [];
      this.exitAngles = [];
      this.completions = 0;
      this.totalEndpoint = 0;
      this.totalInteractions = 0;
      this.escapeRecords.forEach((record) => {
        if (record.size >= this.minimumEnergy) this.addFilteredRecord(record);
      });
    },
    recordDeath(particle, index) {
      this.deaths += 1;
      this.totalInteractions += particle.interactions;
      this.$set(this.particles, index, this.newParticle(index));
    },
    tickParticle(particle, index) {
      const activeIndex = Math.floor(Math.random() * particle.instructions.length);
      const instruction = particle.instructions[activeIndex];
      particle.position[0] += instruction[0] * STEP;
      particle.position[1] += instruction[1] * STEP;
      particle.position[2] += instruction[2] * STEP;
      particle.age += 1;
      if (this.resetProbability > 0) {
        for (let resetIndex = particle.instructions.length - 1; resetIndex >= 0; resetIndex -= 1) {
          if (Math.random() < this.resetProbability) {
            particle.instructions.splice(resetIndex, 1);
            this.resetLosses += 1;
          }
        }
        if (!particle.instructions.length) {
          this.recordDeath(particle, index);
          return;
        }
      }
      const radius = this.radius(particle.position);
      if (particle.age % 2 === 0) {
        particle.trail.push([particle.position[0], particle.position[2]]);
        if (particle.trail.length > 70) particle.trail.shift();
      }
      if (radius >= this.sourceRadius) {
        this.recordEscape(particle, index);
        return;
      }

      if (Math.random() >= this.encounterProbability) return;
      const source = this.randomSource();
      const incoming = this.quantize([
        particle.position[0] - source[0],
        particle.position[1] - source[1],
        particle.position[2] - source[2],
      ]);
      if (!this.perpendicular(instruction, incoming)) return;

      particle.interactions += 1;
      if (Math.random() < 0.5) {
        particle.instructions.push(incoming);
      } else if (particle.instructions.length > 1) {
        particle.instructions.splice(activeIndex, 1);
      } else if (this.allowDeath) {
        this.recordDeath(particle, index);
      }
    },
    simulateTick() {
      this.particles.forEach((particle, index) => this.tickParticle(particle, index));
    },
    animate(time) {
      const delta = this.previousTime ? Math.min(0.05, (time - this.previousTime) / 1000) : 0;
      this.previousTime = time;
      if (this.running) {
        this.accumulator += delta * this.speed * 110;
        while (this.accumulator >= 1) {
          this.simulateTick();
          this.accumulator -= 1;
        }
      }
      this.draw();
      this.animationFrame = requestAnimationFrame(this.animate);
    },
    drawCircle(context, x, y, radius, stroke, fill, dash) {
      context.save();
      context.setLineDash(dash || []);
      context.strokeStyle = stroke;
      context.fillStyle = fill;
      context.lineWidth = 2;
      context.beginPath();
      context.arc(x, y, radius, 0, Math.PI * 2);
      if (fill) context.fill();
      context.stroke();
      context.restore();
    },
    draw() {
      const canvas = this.$refs.canvas;
      if (!canvas) return;
      const context = canvas.getContext('2d');
      const width = canvas.width;
      const height = canvas.height;
      context.fillStyle = '#ffffff';
      context.fillRect(0, 0, width, height);

      const center = { x: 395, y: 415 };
      const outerPixels = 335;
      const scale = outerPixels / this.sourceRadius;
      const sourcePixels = outerPixels;
      this.drawCircle(context, center.x, center.y, sourcePixels, '#1592aa', 'rgba(57,181,204,.08)', []);

      context.fillStyle = 'rgba(21,146,170,.34)';
      this.sourcePoints.forEach((point) => {
        context.beginPath();
        context.arc(center.x + point[0] * sourcePixels, center.y + point[1] * sourcePixels, 2.1, 0, Math.PI * 2);
        context.fill();
      });

      context.font = '700 17px Arial, sans-serif';
      context.fillStyle = '#147f95';
      context.fillText(`SOURCE AREA  A = ${this.sourceArea.toFixed(2)}`, center.x - sourcePixels + 14, center.y - sourcePixels + 30);

      this.particles.forEach((particle, index) => {
        const alpha = index < 24 ? 0.28 : 0.08;
        context.strokeStyle = particle.color;
        context.globalAlpha = alpha;
        context.lineWidth = 1.5;
        context.beginPath();
        particle.trail.forEach((point, trailIndex) => {
          const x = center.x + point[0] * scale;
          const y = center.y - point[1] * scale;
          if (trailIndex === 0) context.moveTo(x, y);
          else context.lineTo(x, y);
        });
        context.stroke();
        context.globalAlpha = index < 55 ? 0.85 : 0.42;
        context.fillStyle = particle.color;
        context.beginPath();
        context.arc(center.x + particle.position[0] * scale, center.y - particle.position[2] * scale,
          2.7 + Math.min(3.2, Math.sqrt(particle.instructions.length) * 0.55), 0, Math.PI * 2);
        context.fill();
      });
      context.globalAlpha = 1;

      this.drawEndpointChart(context, { left: 820, top: 115, width: 675, height: 260 });
      this.drawSurvivalChart(context, { left: 820, top: 485, width: 675, height: 235 });
      this.drawHistogram(context, { left: 820, top: 830, width: 315, height: 145 },
        this.exitSpeeds, 16, 0, 1, 'EXIT SPEED', 'net speed / tick speed', '#3f71d8');
      this.drawHistogram(context, { left: 1180, top: 830, width: 315, height: 145 },
        this.exitAngles, 18, 0, 180, 'EXIT ANGLE', 'degrees from outward', '#8a64d6');
    },
    drawEndpointChart(context, box) {
      context.fillStyle = '#172033';
      context.font = '700 23px Arial, sans-serif';
      context.fillText('ESCAPED ENDPOINTS', box.left, box.top - 35);
      const firstEndpoint = this.minimumEnergy;
      const lastEndpoint = Math.max(firstEndpoint, this.largestEndpoint);
      const endpointBins = lastEndpoint - firstEndpoint + 1;
      const maxObserved = Math.max(1, ...this.endpoints.slice(firstEndpoint, lastEndpoint + 1));

      context.save();
      context.font = '12px Arial, sans-serif';
      context.textAlign = 'right';
      for (let tick = 0; tick <= 4; tick += 1) {
        const count = Math.round(maxObserved * tick / 4);
        const y = box.top + box.height - tick / 4 * box.height;
        context.strokeStyle = tick === 0 ? '#aeb9c8' : '#e2e7ee';
        context.lineWidth = 1;
        context.beginPath();
        context.moveTo(box.left, y);
        context.lineTo(box.left + box.width, y);
        context.stroke();
        context.fillStyle = '#66758b';
        context.fillText(count.toLocaleString(), box.left - 9, y + 4);
      }
      context.translate(box.left - 58, box.top + box.height / 2);
      context.rotate(-Math.PI / 2);
      context.textAlign = 'center';
      context.font = '600 13px Arial, sans-serif';
      context.fillStyle = '#53617a';
      context.fillText('PHOTON COUNT', 0, 0);
      context.restore();

      const slotWidth = box.width / endpointBins;
      const gap = Math.min(5, slotWidth * 0.24);
      const barWidth = Math.max(1, slotWidth - gap);
      const labelEvery = Math.max(1, Math.ceil(endpointBins / 14));
      for (let n = firstEndpoint; n <= lastEndpoint; n += 1) {
        const x = box.left + (n - firstEndpoint) * slotWidth;
        const observedHeight = (this.endpoints[n] || 0) / maxObserved * box.height;
        const expectedCount = n < this.minimumEnergy ? 0
          : this.completions * (1 - this.fittedR) * Math.pow(this.fittedR, n - this.minimumEnergy);
        const expectedHeight = expectedCount / maxObserved * box.height;
        context.fillStyle = 'rgba(19,138,163,.72)';
        context.fillRect(x, box.top + box.height - observedHeight, barWidth, observedHeight);
        context.strokeStyle = '#d1495b';
        context.lineWidth = 2;
        context.strokeRect(x, box.top + box.height - expectedHeight, barWidth, expectedHeight);
        if (n === firstEndpoint || n === lastEndpoint || (n - firstEndpoint) % labelEvery === 0) {
          context.fillStyle = '#66758b';
          context.font = '12px Arial, sans-serif';
          context.fillText(String(n), x + 1, box.top + box.height + 18);
        }
      }
      context.strokeStyle = '#cfd7e2';
      context.beginPath();
      context.moveTo(box.left, box.top + box.height);
      context.lineTo(box.left + box.width, box.top + box.height);
      context.stroke();
      context.font = '14px Arial, sans-serif';
      context.fillStyle = '#138aa3';
      context.fillText('filled: simulation', box.left, box.top + box.height + 46);
      context.fillStyle = '#d1495b';
      context.fillText('outline: fitted geometric', box.left + 160, box.top + box.height + 46);
    },
    drawHistogram(context, box, values, bins, minimum, maximum, title, xLabel, color) {
      context.fillStyle = '#172033';
      context.font = '700 20px Arial, sans-serif';
      context.fillText(title, box.left, box.top - 28);
      const counts = Array(bins).fill(0);
      values.forEach((value) => {
        const fraction = (value - minimum) / (maximum - minimum);
        const bin = Math.max(0, Math.min(bins - 1, Math.floor(fraction * bins)));
        counts[bin] += 1;
      });
      const maxCount = Math.max(1, ...counts);
      context.strokeStyle = '#dfe5ed';
      context.lineWidth = 1;
      context.strokeRect(box.left, box.top, box.width, box.height);
      for (let tick = 1; tick <= 2; tick += 1) {
        const y = box.top + box.height - tick / 2 * box.height;
        context.beginPath();
        context.moveTo(box.left, y);
        context.lineTo(box.left + box.width, y);
        context.stroke();
      }
      const slot = box.width / bins;
      counts.forEach((count, index) => {
        const height = count / maxCount * box.height;
        context.fillStyle = color;
        context.globalAlpha = 0.72;
        context.fillRect(box.left + index * slot + 1, box.top + box.height - height,
          Math.max(1, slot - 2), height);
      });
      context.globalAlpha = 1;
      context.fillStyle = '#66758b';
      context.font = '11px Arial, sans-serif';
      const tickCount = 4;
      for (let tick = 0; tick <= tickCount; tick += 1) {
        const fraction = tick / tickCount;
        const x = box.left + fraction * box.width;
        const value = minimum + fraction * (maximum - minimum);
        context.textAlign = tick === 0 ? 'left' : (tick === tickCount ? 'right' : 'center');
        context.fillText(Number.isInteger(value) ? String(value) : value.toFixed(2),
          x, box.top + box.height + 16);
      }
      context.textAlign = 'center';
      context.fillText(xLabel, box.left + box.width / 2, box.top + box.height + 32);
      context.textAlign = 'left';
      context.fillText(`max count ${maxCount.toLocaleString()}`, box.left, box.top - 9);
    },
    drawSurvivalChart(context, box) {
      context.fillStyle = '#172033';
      context.font = '700 23px Arial, sans-serif';
      context.fillText('TIME BEFORE MEASURED ESCAPE', box.left, box.top - 35);
      context.strokeStyle = '#cfd7e2';
      context.strokeRect(box.left, box.top, box.width, box.height);
      if (this.escapeTimes.length < 20) {
        context.fillStyle = '#7a8799';
        context.font = '16px Arial, sans-serif';
        context.fillText('Collecting escaped particles…', box.left + 20, box.top + 35);
        return;
      }
      const times = this.escapeTimes.slice().sort((a, b) => a - b);
      const minimum = times[0];
      const maximum = times[times.length - 1];
      const timeRange = Math.max(1, maximum - minimum);
      const minimumSurvival = 1 / times.length;
      context.strokeStyle = '#138aa3';
      context.lineWidth = 3;
      context.beginPath();
      for (let i = 0; i <= 60; i += 1) {
        const elapsed = timeRange * i / 60;
        let survivors = 0;
        for (let j = 0; j < times.length; j += 1) {
          if (times[j] - minimum >= elapsed) survivors += 1;
        }
        const survival = Math.max(minimumSurvival, survivors / times.length);
        const x = box.left + i / 60 * box.width;
        const y = box.top + Math.log(survival) / Math.log(minimumSurvival) * box.height;
        if (i === 0) context.moveTo(x, y);
        else context.lineTo(x, y);
      }
      context.stroke();
      context.fillStyle = '#66758b';
      context.font = '12px Arial, sans-serif';
      context.textAlign = 'left';
      context.fillText(`${minimum} ticks`, box.left, box.top + box.height + 17);
      context.textAlign = 'right';
      context.fillText(`${maximum} ticks`, box.left + box.width, box.top + box.height + 17);
      context.textAlign = 'center';
      context.fillText('observed escape time (log survival)', box.left + box.width / 2,
        box.top + box.height + 35);
      context.textAlign = 'left';
    },
  },
};
</script>

<style scoped>
.escape-page,
.escape-page * { box-sizing: border-box; }
.escape-page {
  width: 100%;
  min-height: 100vh;
  padding: 44px clamp(18px, 4vw, 68px) 32px;
  color: #172033;
  background: #fff;
  font-family: Inter, Avenir, Helvetica, Arial, sans-serif;
  text-align: left;
}
.hero { width: min(1250px, 100%); margin: 0 auto 28px; }
.eyebrow { width: auto; color: #168da5; font-size: 12px; font-weight: 800; letter-spacing: .17em; }
h1 { max-width: 1040px; margin: 10px 0 0; font-size: clamp(38px, 5vw, 68px); line-height: .98; letter-spacing: -.045em; }
.hero p { max-width: 920px; margin: 20px 0 0; color: #5f6b80; font-size: 17px; line-height: 1.6; }
.experiment {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 286px;
  width: min(1500px, 100%);
  margin: 0 auto;
  overflow: hidden;
  border: 1px solid #dce2ec;
  border-radius: 24px;
  background: #fff;
  box-shadow: 0 22px 60px rgba(31,45,71,.12);
}
.canvas-wrap { width: auto; min-width: 0; background: #fff; }
canvas { display: block; width: 100%; height: auto; }
.controls { width: auto; padding: 22px; border-left: 1px solid #dce2ec; background: linear-gradient(180deg,#fff,#f5f8fb); }
.control-heading { display: flex; justify-content: space-between; align-items: center; width: auto; margin-bottom: 24px; font-size: 14px; font-weight: 800; }
button { margin: 0; padding: 7px 11px; border: 1px solid #2b9bb2; border-radius: 8px; color: #147f95; background: #fff; cursor: pointer; }
.restart { width: 100%; margin: 3px 0 20px; padding: 10px; font-weight: 700; }
label { display: block; margin-bottom: 20px; color: #68758d; font-size: 12px; }
label span { display: flex; justify-content: space-between; margin-bottom: 8px; }
label b { color: #172033; }
input[type='range'] { width: 100%; accent-color: #1592aa; }
.death-toggle {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 12px;
  border: 1px solid #dce2ec;
  border-radius: 10px;
  background: #fff;
  cursor: pointer;
}
.death-toggle input { width: auto; margin: 2px 0 0; accent-color: #d1495b; }
.death-toggle span { display: block; margin: 0; }
.death-toggle b { display: block; margin-bottom: 4px; }
.death-toggle small { display: block; color: #7a8799; line-height: 1.35; }
.facts { width: auto; border-top: 1px solid #dce2ec; }
.facts div { display: flex; justify-content: space-between; width: auto; padding: 10px 0; border-bottom: 1px solid #e5e9f0; color: #68758d; font-size: 12px; }
.facts b { color: #172033; }
.explanation { display: grid; grid-template-columns: repeat(4,1fr); width: min(1250px,100%); margin: 28px auto 0; border-top: 1px solid #dce2ec; border-bottom: 1px solid #dce2ec; }
.explanation article { width: auto; padding: 22px 20px; border-right: 1px solid #e5e9f0; }
.explanation article:last-child { border-right: 0; }
.explanation span { color: #168da5; font-size: 11px; font-weight: 800; letter-spacing: .12em; }
.explanation h2 { margin: 8px 0; font-size: 17px; }
.explanation p { margin: 0; color: #68758d; font-size: 13px; line-height: 1.55; }
.caution { background: #fff9f3; }
.caution span { color: #c26e22; }
@media (max-width: 1050px) {
  .experiment { grid-template-columns: 1fr; }
  .controls { border-top: 1px solid #dce2ec; border-left: 0; }
  .explanation { grid-template-columns: 1fr 1fr; }
}
@media (max-width: 640px) {
  .escape-page { padding: 28px 12px; }
  .explanation { grid-template-columns: 1fr; }
}
</style>
