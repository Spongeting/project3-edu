<template>
	<div>
		<button @click="$emit('update:a',100)">修改父亲的aa</button>
		<button @click="$emit('abc',100)">修改父亲的bb</button>
		<!--默认插槽-->
		<slot></slot>
		<!--具名插槽-->
		<div>
			<slot name="a1" name1="李四" :age="18"></slot>
		</div>
		<div>
			<slot name="a2"></slot>
		</div>
		<div>
			<slot name="a3"></slot>
		</div>
		<div>
			<slot name="a4" name1="张三" :age="20"></slot>
		</div>
	</div>
</template>

<script type="text/ecmascript-6">
	//被使用方
        export default {
                name:"Demo",
	        props:["a","b"],//对外公开了一个属性a
	        model:{
                        prop:"b",
		        event:"abc"
	        }
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>

</style>