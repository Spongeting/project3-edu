<template>
	<div class="pass">
		<el-form label-width="100px" :model="model" :rules="rules" ref="form" status-icon>
			<el-form-item label="*原始密码：" prop="oldPwd">
				<el-input type="password" v-model="model.oldPwd"></el-input>
			</el-form-item>
			<el-form-item label="新密码：" prop="newPwd">
				<el-input type="password" v-model="model.newPwd"></el-input>
			</el-form-item>
			<el-form-item label="新密码确认：" prop="checkNewPwd">
				<el-input type="password" v-model="model.checkNewPwd"></el-input>
			</el-form-item>
			<el-form-item  prop="save">
				<el-button type="primary" @click="save">确定</el-button>
			</el-form-item>
		</el-form>
	</div>
</template>

<script type="text/ecmascript-6">
        export default {
                name:"ChangePwd",
	        data(){
                        return {
                                model:{
                                        oldPwd:"",
                                        newPwd:"",
	                                checkNewPwd:""
                                },
	                        rules:{
                                        oldPwd:[
	                                        {
	                                                validator:(rules,value,callback) =>{
	                                                        if(value === "")
	                                                                callback(new Error("*原始密码必填！"));
	                                                        else if(value.length <3 || value.length > 20)
	                                                                callback(new Error("*密码长度3 - 20"));
	                                                        else
	                                                                callback();
	                                                },
		                                        trigger:"blur"
	                                        }
                                        ],
		                        newPwd:[
			                        {
                                                        validator:(rules,value,callback) =>{
                                                                if(value === "")
                                                                        callback(new Error("*新密码必填！"));
                                                                else if(value.length <3 || value.length > 20)
                                                                        callback(new Error("*密码长度3 - 20"));
                                                                else if(value === this.model.oldPwd)
                                                                        callback(new Error("新旧密码不能一样！"));
                                                                else
                                                                        callback();
                                                        },
                                                        trigger:"blur"
			                        }
		                        ],
                                        checkNewPwd:[
			                        {
                                                        validator:(rules,value,callback) =>{
                                                                if(value === "")
                                                                        callback(new Error("请再次输入密码！"));
                                                                else if(value !== this.model.newPwd)
                                                                        callback(new Error("两次输入密码不一致！"));
                                                                else
                                                                        callback();
                                                        },
                                                        trigger:"blur"
			                        }
		                        ]
	                        }
                        };
	        },
	        methods:{
	                async save(){
	                        await this.$http({
		                        url:"/user/pwdchange",
		                        method:"post",
		                        data:this.model
	                        });
	                        this.$message({
		                        message:"密码修改成功！",
		                        type:"success"
	                        });
	                }
	        }
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>
	.pass
		width 500px
</style>