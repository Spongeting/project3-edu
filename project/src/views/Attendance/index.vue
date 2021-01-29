<template>
	<div>
		相关组件功能暂无开发 敬请期待！
		<el-upload
			   ref="upload"
			   accept=".jpg,.png"
		           list-type="picture-card"
		           action="/student/avatarupload"
		           name="avatar"
		           :headers="uploadHeaders"
		           :before-upload="beforeAvatarUpload"
			   :on-success="avatarUploadSuccess"
			   :on-remove="avatarRemove">
			<i class="el-icon-plus"></i>
			<p slot="tip">提示：只能上传jpg或png格式的文件，且大小不能超过2M</p>
		</el-upload>
		<el-button :disabled="upload.model.stu_avatar_new === ''" type="primary" @click="aaa">确定</el-button>
	</div>
</template>

<script type="text/ecmascript-6">
        export default {
                name:"Attendance",
	        data() {
                        return {
                                uploadHeaders:{"Authorization": sessionStorage.getItem("token")},
	                        upload:{//头像上传时的相关数据
		                        isUpload:false,
		                        model:{
                                                stu_id:5,
			                        stu_avatar_old:null,
			                        stu_avatar_new:""
		                        }
	                        }
                        };
	        },
	        methods:{
                        beforeAvatarUpload(file){
                                const isJPG = file.type === 'image/jpeg';
                                const isPng = file.type === 'image/png';
                                const isLt2M = file.size / 1024 / 1024 < 2;

                                if ((!isJPG) && (!isPng)) {
                                        this.$message.error('上传头像图片只能是 JPG或png 格式!');
                                }
                                if (!isLt2M) {
                                        this.$message.error('上传头像图片大小不能超过 1MB!');
                                }
                                return (isJPG || isPng) && isLt2M;
                        },
                        avatarUploadSuccess({status,data,message}, file, fileList) {//上传成功以后的钩子函数
	                        switch(status) {
		                        case 200:
		                                this.upload.model.stu_avatar_new = data;
		                                if(fileList.length > 1) fileList.shift();
		                                break;
		                        case 401:

		                        case 404:
		                        case 199:
		                        case 500:
		                                this.$message.error(message);
	                        }
                        },
		        avatarRemove(file,fileList) {
                                this.upload.model.stu_avatar_new = "";
		        },
		        async aaa() {
                                await this.$http({//上传
	                                method:"post",
	                                url:"/student/avatarupdate",
	                                data:this.upload.model
                                });
                                //提示用户上传成功 并且关闭对话框
			        this.$message.success("头像上传更新成功！");
			        //关闭上传头像对话框
			        this.upload.isUpload = false;
			        //重置上传控件 为下一次上传做准备
			        this.$refs.upload.clearFiles();
		        }
	        }
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>
</style>