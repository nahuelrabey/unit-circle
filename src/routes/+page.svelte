<script lang="ts">
	import { onMount } from 'svelte';
	// import { contain } from 'intrinsic-scale';

	let canvas: HTMLCanvasElement;
	let i_angle: number = 45;
	let render: (angle: number) => void;
	onMount(() => {
		const offsetHeight = canvas.offsetHeight;
		const offsetWidth = canvas.offsetWidth;

		const dpi = window.devicePixelRatio;
		const width = offsetWidth * 1.5 * dpi;
		const height = offsetHeight * 1.5 * dpi;

		// This could be defined using width to
		const pixelRatio = offsetHeight / height;
		const offsetToCanvas = (px: number) => px / pixelRatio;
		const canvasToOffset = (px: number) => px * pixelRatio;
		const UNIT = offsetToCanvas((1 / 8) * window.innerWidth);

		canvas.setAttribute('width', width.toString());
		canvas.setAttribute('height', height.toString());
		console.log(`resolution = (${width},${height})`);
		console.log(`offset = (${offsetWidth}, ${offsetHeight})`);
		console.log(`pixel ratio = ${pixelRatio}`);
		console.log(`UNIT = ${UNIT}px`);
		console.log(`1UNIT = ${UNIT}px`);
		console.log(`1UNIT in Canvas= ${offsetToCanvas(UNIT)}px`);

		const ctx = canvas.getContext('2d');
		if (ctx === null) {
			return;
		}

		const XCOLOR = '#44CF6C';
		const YCOLOR = '#ED254E';

		ctx.translate(canvas.width / 2, canvas.height / 2);
		render = (value: number) => {
			ctx.moveTo(0, 0);
			ctx.clearRect(-width / 2, -height / 2, width, height);

			// DRAWING x-axis
			ctx.beginPath();
			ctx.moveTo(-2 * UNIT, 0);
			ctx.lineTo(2 * UNIT, 0);
			ctx.lineWidth = offsetToCanvas(1);
			ctx.strokeStyle = '#757575';
			ctx.stroke();
			ctx.closePath();

			// DRAWIN x steps
			ctx.beginPath();
			for (let i = -2; i <= 2; i += 0.25) {
				ctx.moveTo(i * UNIT, 0);
				ctx.fillStyle = '#757575';
				ctx.fillRect(i * UNIT, offsetToCanvas(-3), offsetToCanvas(1), offsetToCanvas(6));
			}
			ctx.closePath();

			// DRAWING y-axis
			ctx.beginPath();
			ctx.moveTo(0, -2 * UNIT);
			ctx.lineTo(0, 2 * UNIT);
			ctx.lineWidth = offsetToCanvas(1);
			ctx.strokeStyle = '#757575';
			ctx.stroke();
			ctx.closePath();

			// DRAWIN y steps
			ctx.beginPath();
			for (let i = -2; i <= 2; i += 0.25) {
				ctx.moveTo(0, i * UNIT);
				ctx.fillStyle = '#757575';
				ctx.fillRect(offsetToCanvas(-3), i * UNIT, offsetToCanvas(6), offsetToCanvas(1));
			}
			ctx.closePath();

			// DRAWING circle
			ctx.beginPath();
			ctx.arc(0, 0, UNIT, 0, 2 * Math.PI);
			ctx.lineWidth = offsetToCanvas(2.5);
			ctx.stroke();
			ctx.closePath();

			/**
			 * -x + 90 corrects angle deviation. I don't know why dis deviation
			 * occurs, but this solves it
			 */
			const angle = ((-value + 90) * Math.PI) / 180;
			const x = Math.sin(angle);
			const y = Math.cos(angle);
			// console.log(`angle = ${angle}`);
			// console.log(`sin = ${x} = ${x * UNIT}`);
			// console.log(`cos = ${y} = ${y * UNIT}`);

			// DRAWING adyacent vector aka x-value
			ctx.beginPath();
			ctx.moveTo(0, 0);
			ctx.lineTo(x * UNIT, 0);
			ctx.strokeStyle = XCOLOR;
			ctx.stroke();
			ctx.closePath();

			// DRAWING oposite vector aka y-value
			ctx.beginPath();
			ctx.beginPath();
			ctx.moveTo(x * UNIT, 0);
			ctx.lineTo(x * UNIT, -y * UNIT);
			ctx.strokeStyle = YCOLOR;
			ctx.stroke();
			ctx.closePath();

			// DRAWING hipothenuse vector
			ctx.beginPath();
			ctx.moveTo(0, 0);
			ctx.lineTo(x * UNIT, -y * UNIT);
			ctx.strokeStyle = '#1C1D21';
			ctx.stroke();
			ctx.closePath();

			/* ----------------------------- DRAWING VALUES ----------------------------- */

			// sine aka x-value
			ctx.beginPath();
			ctx.font = `${offsetToCanvas(12)}px Arial`;
			ctx.fillStyle = XCOLOR;
			ctx.fillText(`sine = ${x}`, 1.25 * UNIT, -UNIT);
			ctx.closePath();

			// cosine aka y-value
			ctx.beginPath();
			ctx.font = `${offsetToCanvas(12)}px Arial`;
			ctx.fillStyle = YCOLOR;
			ctx.fillText(`cos  = ${y}`, 1.25 * UNIT, -0.9 * UNIT);
			ctx.closePath();
		};

		render(i_angle);
	});

	$: {
		if (typeof render === 'function') {
			render(i_angle);
		}
	}
</script>

<main>
	<h1>The Unit Circle!</h1>
	<div id="controller">
		<label for="anlge">set angle</label>
		<input type="number" name="angle" id="angle" bind:value={i_angle} />
		<input
			type="range"
			name="angle_range"
			id="angle_range"
			bind:value={i_angle}
			min={-360}
			max={360}
		/>
	</div>
	<canvas bind:this={canvas} />
</main>

<style>
	main {
		color: rgb(28, 29, 33);
	}
	h1 {
		text-align: center;
		font-family: sans-serif;
	}
	input::-webkit-outer-spin-button,
	input::-webkit-inner-spin-button {
		-webkit-appearance: none;
		margin: 0;
	}

	/* Firefox */
	input[type='number'] {
		-moz-appearance: textfield;
	}
	#controller {
		font-family: sans-serif;
		width: 400px;
		display: flex;
		flex-flow: row;
		justify-content: space-evenly;
		margin: 2em auto;
	}
	#controller input[type='number'] {
		text-align: center;
		width: 4em;
	}
	canvas {
		margin: auto;
		display: block;
		height: 400px;
	}
</style>
