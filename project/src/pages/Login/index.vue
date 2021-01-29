<template>
	<div>
		<div class="wrapper">
			<ul class="bg-bubbles">
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
				<li></li>
			</ul>
		</div>
		<div class="logo-wrapper">
			<h1>青岛滨海学院管理系统</h1>
		</div>
		<el-form :rules="rules" :model="model" ref="model" status-icon>
			<h2>青岛滨海学院管理系统</h2>
			<el-form-item prop="user_name">
				<el-input suffix-icon="el-icon-s-custom" v-model="model.user_name" placeholder="请输入用户名">
					<template slot="prepend"><span class="prepend-text">用户名：</span></template>
				</el-input>
			</el-form-item>
			<el-form-item prop="user_pwd">
				<el-input  suffix-icon="el-icon-lock" v-model="model.user_pwd" show-password placeholder="请输入密码">
					<template slot="prepend"><span class="prepend-text">密码：</span></template>
				</el-input>
			</el-form-item>
			<el-form-item class="button-wrapper">
				<el-button plain @click="login('model')">登录</el-button>
			</el-form-item>
		</el-form>
	</div>
</template>

<script type="text/ecmascript-6">
        export  default {
                name:"Login",
	        data() {
                 return {
                         model:{
                                 user_name:"",
                                 user_pwd: ""
                         },
	                 //表单验证
	                 rules:{
                                 user_name:[
                                         { required: true, message: '* 请输入用户名', trigger: 'blur' },
                                         { min: 3, max: 20, message: '* 长度在 3 到 20 个字符', trigger: 'blur' }
                                 ],
                                 user_pwd:[
                                         {  required: true, message: '* 请输入密码', trigger: 'blur' },
                                         { min: 3, max: 20, message: '* 长度在 3 到 20 个字符', trigger: 'blur' }
		                 ]
	                 },
                 };
	        },
	        methods:{
                       // validate:表单的校验方法
		        //对整个表单进行校验 参数是一个回调函数 这个回调函数会在表单验证结束后被调用
		        //这个回调函数会自动收到两个参数 ：是否校验成功和未通过校验的字段
		        //如果不传人回调函数，就会返回一个promise
                        login(model) {
                                this.$refs[model].validate(async valid =>{
                                        if(valid){
                                                let token =  await this.$http({
                                                        url:"/user/login",
                                                        method:"post",
                                                        data:this.model
                                                });
                                                sessionStorage.setItem("token",token);
                                                sessionStorage.setItem("user_name",this.model.user_name);
                                                this.$router.replace("/home");
                                        }else{
                                                console.log('error submit!!');
                                                return false;
                                               /* alert("请正确填写您的信息！")*/
                                        }
                                });
                        },
	        },
        };
</script>

<style lang="stylus" type="text/stylus" scoped >
	.wrapper {
		background: #2c8ba3;
		background: -webkit-linear-gradient(top left, #2c8ba3 0%, #77dce3 100%);
		background: linear-gradient(to bottom right, #2c8ba3 0%, #77dce3 100%);
		position: absolute;
		top: 31%;
		left: 0;
		z-index:-1000;
		width: 100%;
		height: 100%;
		margin-top: -200px;
		overflow: hidden;
	}
	.bg-bubbles {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: 1;
	}
	.bg-bubbles li {
		position: absolute;
		list-style: none;
		display: block;
		width: 40px;
		height: 40px;
		border-radius: 50%;
		background-color: rgba(255, 255, 255, 0.15);
		bottom: -160px;
		-webkit-animation: square 25s infinite;
		animation: square 25s infinite;
		-webkit-transition-timing-function: linear;
		transition-timing-function: linear;
	}
	.bg-bubbles li:nth-child(1) {
		left: 10%;
	}
	.bg-bubbles li:nth-child(2) {
		left: 20%;
		width: 80px;
		height: 80px;
		-webkit-animation-delay: 2s;
		animation-delay: 2s;
		-webkit-animation-duration: 17s;
		animation-duration: 17s;
	}
	.bg-bubbles li:nth-child(3) {
		left: 25%;
		-webkit-animation-delay: 4s;
		animation-delay: 4s;
	}
	.bg-bubbles li:nth-child(4) {
		left: 40%;
		width: 60px;
		height: 60px;
		-webkit-animation-duration: 22s;
		animation-duration: 22s;
		background-color: rgba(255, 255, 255, 0.25);
	}
	.bg-bubbles li:nth-child(5) {
		left: 70%;
	}
	.bg-bubbles li:nth-child(6) {
		left: 80%;
		width: 120px;
		height: 120px;
		-webkit-animation-delay: 3s;
		animation-delay: 3s;
		background-color: rgba(255, 255, 255, 0.2);
	}
	.bg-bubbles li:nth-child(7) {
		left: 32%;
		width: 160px;
		height: 160px;
		-webkit-animation-delay: 7s;
		animation-delay: 7s;
	}
	.bg-bubbles li:nth-child(8) {
		left: 55%;
		width: 20px;
		height: 20px;
		-webkit-animation-delay: 15s;
		animation-delay: 15s;
		-webkit-animation-duration: 40s;
		animation-duration: 40s;
	}
	.bg-bubbles li:nth-child(9) {
		left: 25%;
		width: 10px;
		height: 10px;
		-webkit-animation-delay: 2s;
		animation-delay: 2s;
		-webkit-animation-duration: 40s;
		animation-duration: 40s;
		background-color: rgba(255, 255, 255, 0.3);
	}
	.bg-bubbles li:nth-child(10) {
		left: 90%;
		width: 160px;
		height: 160px;
		-webkit-animation-delay: 11s;
		animation-delay: 11s;
	}
	@-webkit-keyframes square {
		0% {
			-webkit-transform: translateY(0);
			transform: translateY(0);
		}
		100% {
			-webkit-transform: translateY(-700px) rotate(600deg);
			transform: translateY(-700px) rotate(600deg);
		}
	}
	@keyframes square {
		0% {
			-webkit-transform: translateY(0);
			transform: translateY(0);
		}
		100% {
			-webkit-transform: translateY(-700px) rotate(600deg);
			transform: translateY(-700px) rotate(600deg);
		}
	}
	@keyframes aaa
		0%{ transform: rotateY(0deg)}
		100%{ transform: rotateY(28deg)}
	@keyframes bbb
		0%{ transform:translateY(-50%) translateX(0%) }
		100%{ transform:translateY(-50%) translateX(23%) }
	.logo-wrapper
		perspective 500px
		position: fixed
		top: 50%
		right: 50%
		transform:  translateY(-50%) translateX(0%)
		animation-name:bbb
		animation-duration: 1s
		animation-fill-mode: forwards
		animation-delay:1s
		h1
			animation-name:aaa
			animation-duration: 1s
			animation-fill-mode: forwards
			/*border-bottom: 1px solid black*/
			padding:30px 50px
			white-space: nowrap
			color:#b0b0b0
			transform: rotateY(28deg)
			transform-origin :left center
			text-shadow: -15px 15px 10px black
			font-size: 60px
			position: relative
			/*&:before
				content :"青岛滨海学院教务管理系统"
				position:absolute
				left :0
				top:100%
				padding:30px 50px
				transform:scaleY(-0.8)*/
	.el-form
		position: fixed
		top:50%
		left: 50%
		transform:translateY(-50%)
		box-shadow: 0 0 10px 1px #333
		background-color #fff
		width: 320px
		border-radius:8px
		padding: 30px 50px
		span.prepend-text
			display inline-block
			width 60px
		.button-wrapper
			text-align center
		h2
			text-align center
			margin-bottom 30px
			font-size 24px
</style>