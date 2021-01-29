<template>
	<div>
		<el-row :gutter="20">
			<el-col v-for="item in list" :key="item.role_id" :span="6">
				<el-card shadow="hover" >
					<span v-text="item.role_name"></span>
					<div class="button-wrapper">
						<el-button type="text" @click="beginUpdate(item)">
							<i class="el-icon-edit-outline"></i>
						</el-button>
						<el-button type="text" @click="remove(item)" >
							<i class="el-icon-delete"></i>
						</el-button>
						<el-button type="text" @click="beginRoleFuncConfig(item.role_id)">
							<i class="el-icon-s-tools"></i>
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
		<el-dialog :title= "edit.mode ? '角色管理 - 新增' : '角色管理 - 修改' " :visible="edit.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false" center width="600px">
			<el-form label-width="140px" ref="form" :model="edit.model" :rules="edit.rules">
				<el-form-item label="角色名称：" prop="role_name">
					<el-input v-model.trim="edit.model.role_name" placeholder="-请输入角色名称-"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit.isEdit=false" plain>取消</el-button>
				<el-button type="primary" @click="save">确定</el-button>
			</div>
		</el-dialog>
		<!--Drawer-->
		<el-drawer class="custom-drawer"
			           :modal="false"
			           :visible.sync="edit2.isEdit"
			           size="600px"
			           :show-close="false">
			<el-container>
				<el-header >角色功能分配</el-header>
				<el-main>
					<el-tree class="custom-tree" :data="edit2.treeData" default-expand-all :expand-on-click-node="false" >
				<span class="custom-tree-node" slot-scope="{node,data}" :class="{parent:data.func_key==='' }">
					<span>
						<i v-if="data.func_key !== '' " class="el-icon-paperclip"></i>
						<span v-text="data.func_name"></span>
					</span>
					<span class="switch-wrapper">
						<el-switch v-model="data.open" @change="switchChangeHandler(data)"></el-switch>
					</span>
				</span>
					</el-tree>
				</el-main>
				<el-footer>
					<div class="drawer-footer">
						<el-button type="primary" @click="roleFuncConfig">确定</el-button>
						<el-button @click="edit2.isEdit = false">取消</el-button>
					</div>
				</el-footer>
			</el-container>
		</el-drawer>
	</div>
</template>

<script type="text/ecmascript-6">
	//起别名 一个组件要用两个仓库的数据 为了避免两个仓库中的方法冲突  可以给两个仓库中的方法起别名
	import {createNamespacedHelpers} from 'vuex';
	let {mapState:mapStateFromRole, mapActions:mapActionsFromRole} = createNamespacedHelpers("role");
        let {mapActions:mapActionsFromFunc, mapGetters:mapGettersFromFunc} = createNamespacedHelpers("func");

        export default {
                name:"Role",
	        data() {
                        return{
                                //roles:[],//渲染初始化的默认值
	                        edit:{
                                       isEdit:false,//是否进入编辑
		                       mode:true,//true：表示新增 false：表示修改
		                       model:{
                                               role_id:0,
			                       role_name:""
		                       },
		                        rules:{
                                               role_name:[
                                                       {
                                                          validator:(rule,value,callback) => {
                                                                  //解构赋值
	                                                          let {role_id,role_name} = this.edit.model;
	                                                          if(value.length === 0)
	                                                                  callback(new Error('* 角色名称不能为空'));
	                                                          else if(value.length <2 || value.length >20)
	                                                                  callback(new Error('*角色名称长度2 - 20'));
	                                                          else if(this.list.some(item => item.role_id !== role_id && item.role_name === role_name))
	                                                                  callback(new Error('*角色名称已存在'));
	                                                          else
	                                                                  callback();
                                                          },
	                                                  trigger:"blur"
                                                       }
	                                        ]
		                        }
	                         },
	                        edit2:{
	                                isEdit:false,//表示有没有进入角色功能分配
		                        model:{role_id:0,  role_func_ids:""},//模板
		                        treeData:[],//驱动树 和树实际绑定的数据
	                        }
                        };
	        },
	        created (){
                       this.init();//获取所有角色
		       this.initFunc();//获取所有功能
			//this.roles = await this.$http({url:"/role/all"});
			//console.log(this.roles);
	      },
	        computed: { //去壳
                        ...mapStateFromRole(["list"]),//角色仓库 去壳
                        ...mapGettersFromFunc(["listToTree"]),
                },
	        methods:{
	                //避免方法中调用函数的名字冲突 可以起别名  键名是别名 键值 函数名
//                        ...mapActionsFromRole({init:"initRole",removeRole, addRole, updateRole}),
		        ...mapActionsFromRole(["init","removeRole","addRole","updateRole"]),
		        ...mapActionsFromFunc({"initFunc":"init"}),
	                //删除
		        remove(node) {
		              this.$confirm(`您确定要删除 "${node.role_name}"角色吗？`,"警告", {type:"warning"})
			              .then(async () => {
			                      await this.removeRole(node.role_id);
			                      this.$message({
				                      message:`${node.role_name} 角色，删除成功！请刷新页面 查看最新菜单...`  ,
				                      type:"success"
			                      });
			              })
			              .catch(() => {});
		        },
//		        新增
                        beginAdd() {
		                //重置表单
	                        this.$refs.form && this.$refs.form.resetFields();
	                        this.edit.mode = true;//开始新增
                                this.edit.model.role_id = 0;
                                this.edit.model.role_name = "";
				this.edit.isEdit = true;//打开对话框开始新增
	                },
		       // 修改
                        beginUpdate(node) {
                                //重置表单
                                this.$refs.form && this.$refs.form.resetFields();
                                this.edit.mode = false;//开始修改
	                        this.edit.model.role_id =  node.role_id;
	                        this.edit.model.role_name = node.role_name;
                                this.edit.isEdit = true;//打开对话框开始修改
                        },
//		        保存
		        save() {
		                this.$refs.form.validate(async valid =>{
		                        if(!valid) return;
                                        if(this.edit.mode){//新增
                                               await this.addRole(Object.assign({},this.edit.model));
                                                this.$message({
                                                        message:`${this.edit.model.role_name} 角色，新增成功！`,
                                                        type:"success"
                                                });
                                        }else{//修改
                                                await this.updateRole(Object.assign({},this.edit.model));
                                                this.$message({
                                                        message:`${this.edit.model.role_name} 角色，修改成功！`,
                                                        type:"success"
                                                });
                                        }
                                        this.edit.isEdit = false;//关闭编辑的对话框
		                });
		        },
                        //更新树的数据 主要作用拿当前最新listToTree和roleFuncIds 得出一个全新的treeData
		        // 深复制以后 给每一项数据动态绑定一个open属性
		        //为什么不能直接把listToTree 给树  因为是计算属性得出的 只能用不能改
                        updateTreeData(roleFuncIds){
                                let  result = JSON.parse(JSON.stringify(this.listToTree));//深复制
                                result.forEach(item => {
                                        item.open = roleFuncIds.indexOf(item.func_id) !== -1;
                                        item.children && item.children.forEach(item2 => item2.open = roleFuncIds.indexOf(item2.func_id) !== -1);
                                });
                                this.edit2.treeData = result;
                        },
		        //角色功能分配
                       async beginRoleFuncConfig(role_id){
		                //准备工作 把点击的角色的当前的功能亮起来 将edit2中的数据初始化好
	                       //发送ajax后返回一堆数据中 只需要func_id
	                       let roleFuncs = await this.$http({ url:"/role_function/list/"+role_id });
	                       console.log(roleFuncs);
	                       let roleFuncIds = roleFuncs.reduce((result,item) => {
	                               result.push(item.func_id);
	                               return result;
	                       },[]);
	                       this.updateTreeData(roleFuncIds);
	                       this.edit2.model.role_func_ids ="";
	                       this.edit2.model.role_id = role_id;
		                //开始角色分配
				this.edit2.isEdit = true;
                        },
                        switchChangeHandler(node){ //全选反选 进入这个函数的时候 双向绑定 已经更新好
                               if(node.func_key ==="") {//非叶子节点  父联动子
                                   node.children && node.children.forEach(item => item.open = node.open);
                               }else { //叶子节点 看有选中的就选 没有选中的就不选
                                    let parent = this.edit2.treeData.find(item => item.func_id == node.func_fid);
                                    if(parent) parent.open = parent.children.some(item => item.open);
                               }
                        },
		        async roleFuncConfig() {//点击确定
                                //发ajax前 统计树中所有open节点的func_id
	                        let func_ids = [];
	                        this.edit2.treeData.forEach(item => {
	                                 if(item.open) func_ids.push(item.func_id);
	                                  item.children && item.children.forEach(item2 => {
	                                         if(item2.open) func_ids.push(item2.func_id);
	                                 })
	                        });
	                        this.edit2.model.role_func_ids = func_ids.join(",");

	                        //发ajax
				await this.$http({
					method:"post",
					url:"role_function/config",
					data:this.edit2.model
				});
	                        //ajax成功返回后相应界面变化
	                        this.edit2.isEdit = false;
	                        this.$message({message:"角色功能分配成功！", type:"success"});
                        }
	        },
	        watch: {
		        listToTree(){//放func页面功能变化时候 role页面需要先退出编辑状态
			        // 然后在去更新treeData中的数据
		                this.edit2.isEdit = false; //退出编辑状态之后 没有角色分配 所以当前应该谁都不指向 传一个空数组过去
	                        this.updateTreeData([]);
		        }
	        }
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>
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
	.el-container
		height:100%
		flex-direction:column
		display:flex
		.el-header
			flex-shrink: 0
		.el-main
			flex: 1
			overflow:auto
		.el-footer
			flex-shrink:0
			.custom-tree
				width: 500px
				margin: 20px 0 50px 50px
				span.custom-tree-node
					flex: 1
					display: flex
					justify-content: space-between
					align-items: center
					&.parent
						padding-right: 50px
						color: #0094ff
			.drawer-footer
				text-align: center
</style>