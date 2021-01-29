<template>
	<div>
		<div class="header">
			<div>
				<span class="green"></span>闲置
			</div>
			<div>
				<span class="orange"></span>使用中
			</div>
		</div>
		<el-row :gutter="20">
			<el-col :span="6" v-for="item in list" :key="item.clsr_name">
				<el-card shadow="hover" :class="{occupys:item.clsr_occupy}">
					<span v-text="item.clsr_name"></span>
					<div class="button-wrapper">
						<el-button type="text" @click="beginUpdate(item)">
							<i class="el-icon-edit-outline"></i>
						</el-button>
						<el-button type="text" v-show="item.clsr_occupy !== 1 " @click="remove(item)">
							<i class="el-icon-delete"></i>
						</el-button>
					</div>
				</el-card>
			</el-col>
			<el-col :span="6">
				<el-card class="btn-add" @click.native.stop="beginAdd">
					<i class="el-icon-plus"></i>
				</el-card>
			</el-col>
		</el-row>
		<!--dialog-->
		<el-dialog :title="edit.mode ? '教室管理 - 新增' : '教室管理 - 修改' " :modal="false" :visible = "edit.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false" width="600px">
			<el-form label-width="140px" ref="form" :model="edit.model" :rules="edit.rules">
				<el-form-item label="教室名称：" prop="clsr_name">
					<el-input v-model.trim="edit.model.clsr_name" placeholder="- 请输入教室名称 -"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit.isEdit=false" plain>取消</el-button>
				<el-button type="primary" @click="save">确定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script type="text/ecmascript-6">
	import {createNamespacedHelpers} from 'vuex';
	let{mapState,mapActions} = createNamespacedHelpers('classroom');

        export default {
                name:"Classroom",
	        data() {
                        return {
	                        edit:{
                                        isEdit:false,//是否进入编辑模式
		                        mode:true,//true:新增 false：修改
		                        model:{
                                                clsr_name:"",
                                                clsr_id:0
		                        },
		                        rules:{
                                                clsr_name:[
	                                                {
	                                                     validator:(rule,value,callback) => {
	                                                             let {clsr_name,clsr_id} = this.edit.model;
	                                                             if(value.length === 0)
	                                                                     callback(new Error("*教室名称不能为空"));
		                                                     else if(value.length < 5 || value.length > 20)
		                                                             callback(new Error("教室名称长度 5 - 20"));
		                                                     else if(this.list.some(item => item.clsr_id !== clsr_id && item.clsr_name === clsr_name))
		                                                             callback(new Error("教室名称已存在"));
		                                                     else
		                                                             callback();
	                                                     },
		                                             trigger:"blur"
	                                                }
                                                ]
		                        },
	                        }
                        };
	        },
	        created() {
                        this.init();
	        },
	        computed:{
		        ...mapState(["list"]),
	        },
	        methods:{
		        ...mapActions(["init","removeClsr","addClsr","updateClsr"]),
		        //删除
		        remove(node) {
		                //console.log(node.clsr_id);
		                this.$confirm(`您确定要删除 "${node.clsr_name}" 教室吗？`,"警告",{type:"warning"})
			                .then(async () =>{
			                        await  this.removeClsr(node.clsr_id);
			                        this.$message({
				                        message:`${node.clsr_name} 教室，删除成功！`,
				                        type:"success"
			                        });
			                })
			                .catch(() => {});
		        },
		        //新增
		        beginAdd() {
		                this.$refs.form && this.$refs.form.resetFields();
		                this.edit.mode = true;
		                this.edit.model.clsr_name = "";
		                this.edit.model.clsr_id = 0;
		                this.edit.isEdit = true;
		        },
		        //修改
                        beginUpdate(node) {
		                console.log(node);
		                this.$refs.form && this.$refs.form.resetFields();
		                this.edit.mode = false;
		                this.edit.model.clsr_id = node.clsr_id;
		                this.edit.model.clsr_name = node.clsr_name;
                                this.edit.isEdit = true;
		        },
		        // 保存
		        save() {
                                this.$refs.form.validate(async valid =>{
		                        if(!valid) return;
		                        if(this.edit.mode){//新增
						await this.addClsr(Object.assign({},this.edit.model));
						this.$message({
							message:`${this.edit.model.clsr_name}教室，新增成功！`,
							type:"success"
						});
		                        }else{//修改
			                        await this.updateClsr(Object.assign({},this.edit.model));
			                        this.$message({
                                                        message:`${this.edit.model.clsr_name}教室，修改成功！`,
                                                        type:"success"
			                        });
		                        }
		                        this.edit.isEdit = false;
		                });
		        }
	        }
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>
	.header
		display :flex
		div
			display:flex
			align-items center
			margin 0 10px
			.green
				width:24px
				height:24px
				background-color: cadetblue
				margin 0 10px
			.orange
				width:24px
				height:24px
				background-color:darkorange
				margin 0 10px
	.el-col
		margin-top: 30px
		.el-card
			text-align: center
			padding:10% 0
			background-color:cadetblue
			color: #ffffff
			font-weight:600
			font-size: 20px
			cursor pointer
			position relative
			&.occupys
				background-color:darkorange
			&.btn-add
				border:1px dashed cadetblue
				background-color:#fff
				color:cadetblue
				box-sizing: border-box
			.button-wrapper
				position:absolute
				right:10px
				bottom:0
				.el-button
					font-size:18px
					color:#fff
</style>