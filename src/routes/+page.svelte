<script lang="ts">
	import { onMount } from 'svelte';
	// import { contain } from 'intrinsic-scale';

	let canvas: HTMLCanvasElement;
	let i_angle: number = 45;
	let render: () => void;
	onMount(() => {
		const UNIT = (1 / 2) * window.innerWidth;
		const offsetHeight = canvas.offsetHeight;
		const offsetWidth = canvas.offsetWidth;

		const dpi = window.devicePixelRatio;
		const width = offsetWidth * 1.5 * dpi;
		const height = offsetHeight * 1.5 * dpi;

		// This could be defined using width to
		const pixelRatio = offsetHeight / height;
		const offsetToCanvas = (px: number) => px / pixelRatio;
		const canvasToOffset = (px: number) => px * pixelRatio;

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

		ctx.translate(canvas.width / 2, canvas.height / 2);
		render = () => {
			ctx.moveTo(0, 0);
			ctx.clearRect(-width / 2, -height / 2, width, height);

			ctx.beginPath();
			ctx.rect(0, 0, UNIT, 0);
			ctx.rect(0, 0, -UNIT, 0);
			ctx.lineWidth = offsetToCanvas(2);
			ctx.strokeStyle = '#757575';
			ctx.stroke();
			ctx.closePath();

			ctx.beginPath();
			ctx.arc(0, 0, UNIT, 0, 2 * Math.PI);
			ctx.lineWidth = offsetToCanvas(2.5);
			ctx.stroke();
			ctx.closePath();

            /**
             * -x + 90 corrects angle deviation. I don't know why dis deviation
             * occurs, but this solves it
             */
			const angle = ((-i_angle + 90) * Math.PI) / 180;
			const x = Math.sin(angle);
			const y = Math.cos(angle);
			console.log(`angle = ${angle}`);
			console.log(`sin = ${x} = ${x * UNIT}`);
			console.log(`cos = ${y} = ${y * UNIT}`);

			ctx.beginPath();
			ctx.moveTo(0, 0);
			ctx.lineTo(x * UNIT, 0);
			ctx.strokeStyle = '#44CF6C';
			ctx.stroke();
			ctx.closePath();

			ctx.beginPath();
			ctx.moveTo(x * UNIT, 0);
			ctx.lineTo(x * UNIT, -y * UNIT);
			ctx.strokeStyle = '#ED254E';
			ctx.stroke();
			ctx.closePath();

			ctx.beginPath();
			ctx.moveTo(0, 0);
			ctx.lineTo(x * UNIT, -y * UNIT);
			ctx.strokeStyle = '#1C1D21';
			ctx.stroke();
			ctx.closePath();
		};

        render()
	});
    function onchange(){
        if (render === undefined){
            return null
        }
        render()
    }
</script>

<main>
	<h1>The Unit Circle!</h1>
	<div>
		<label for="anlge">set angle</label>
		<input type="number" name="angle" id="angle" bind:value={i_angle} on:change={onchange}/>
	</div>
	<div id="container">
		<canvas bind:this={canvas} />
	</div>
</main>

<style>
	main {
		color: rgb(28, 29, 33);
	}
	h1 {
		text-align: center;
		font-family: sans-serif;
	}
	canvas {
		margin: auto;
		display: block;
		height: 400px;
	}
</style>
