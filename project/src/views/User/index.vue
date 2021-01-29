<template>
	<div>
		<el-container>
			<el-header>
				<!--表单-->
				<el-form :inline="true">
					<el-form-item label="用户名：">
						<el-input  v-model.trim=" search.user_name"
						           clearable prefix-icon="el-icon-search"
						           placeholder="请输入搜索内容"
						           @change="getData()"></el-input>
					</el-form-item>
					<el-form-item label="用户角色：">
						<el-select v-model=" search.role_id"
						           @change="getData()">
							<el-option label="- 全部 -" :value="-1"></el-option>
							<el-option label=" - 暂无角色 -" :value="0"></el-option>
							<el-option
								v-for="role in roleList"
								:key="role.role_id"
								:label="role.role_name"
								:value="role.role_id"
							></el-option>
						</el-select>
					</el-form-item>
					<el-form-item>
						<el-button type="success" @click="beginAdd">+ 新增</el-button>
					</el-form-item>
				</el-form>
			</el-header>
			<el-main>
				<!--表格-->
				<el-table :data="users" stripe  border  style="width: 100%">
					<el-table-column label="#"  width="80" align="center" type="index" ></el-table-column>
					<el-table-column label="姓名" prop="user_name"  width="180"></el-table-column>
					<el-table-column label="用户角色"  width="180"  align="center">
						<template slot-scope="{row}">
							<span v-if="row.role_id !== null && roleList.length > 0" v-text="roleList.find(item => item.role_id === row.role_id).role_name"></span>
							<span v-else class="norole">无角色</span>
						</template>
					</el-table-column>
					<el-table-column label="操作">
						<template slot-scope="{row}">
							<el-button type="primary" @click="beginUpdate(row)" icon="el-icon-edit-outline">编辑</el-button>
							<el-button type="danger" @click="remove(row.user_name)"  icon="el-icon-delete">删除</el-button>
							<el-popover  placement="right" trigger="click" title="角色分配">
								<el-button @click="beginRoleFuncConfig(row)"  slot="reference" type="success" icon="el-icon-setting">角色分配</el-button>
								<el-form inline>
									<el-form-item label="角色：">
										<el-select v-model="edit.model.role_id">
											<el-option label="- 无角色 -" :value="0"></el-option>
											<el-option
												v-for="role in roleList"
												:key="role.role_id"
												:label="role.role_name"
												:value="role.role_id"
											></el-option>
										</el-select>
									</el-form-item>
									<el-form-item>
										<el-button plain size="medium" @click="roleFuncConfig">分配</el-button>
									</el-form-item>
								</el-form>
							</el-popover>
						</template>
					</el-table-column>
				</el-table>
			</el-main>
			<el-footer>
				<!--分页器-->
				<el-pagination background
				               :total="pagination.total"
				               :page-size.sync="pagination.pageSize"
				               :current-page.sync="pagination.currentPage"
				               layout="prev,pager,next,jumper,->,sizes,total"
				               :page-sizes="[5,10,15,20]"
				               @size-change="getData()"
				               @current-change="getData(false)">
				</el-pagination>
			</el-footer>
		</el-container>
		<!--弹层-->
		<el-dialog :modal="false" :visible="edit.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false"  width="600px">
			<h3 slot="title" v-text="`用户编辑 - ${edit.mode ? '新增' : '修改'}`"></h3>
			<el-form label-width="100px" :model="edit.model" :rules="edit.rules" ref="form" status-icon @validate="formValidateHandler" >
				<el-form-item label="用户名："  prop="user_name">
					<el-input v-model.trim="edit.model.user_name" placeholder="请输入用户名称" :disabled="!edit.mode"></el-input>
				</el-form-item>
				<el-form-item label="用户密码："  prop="user_pwd">
					<el-input v-model="edit.model.user_pwd" placeholder="请输入用户密码"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit.isEdit = false">取消</el-button>
				<el-button type="primary" @click="save">确定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script type="text/ecmascript-6">
	import {createNamespacedHelpers} from 'vuex';
	let {mapState,mapActions} = createNamespacedHelpers("role");

	export  default {
	        name:"User",
		data() {
	                return {
				users: [],//存放初始数据
		                search: {//搜索框组件的数据
                                        user_name:"",
                                        role_id:-1,
		                },
                                pagination:{//分页器组件的数据
                                        total:0,
                                        pageSize:6,
                                        currentPage:1//想看第几页
                                },
		                edit:{
				        //isPopover:false,//弹出框是否可见
				        mode:true,//true:新增 false:修改
			                isEdit:false,//是否进入编辑状态
			                model:{
				                user_name:"",
				                user_pwd:"",
                                                role_id:null,
			                },
			                rules:{
				             user_name:[
					             {
					                     validator: async (rule,value,callback) => {
					                             if(!this.edit.mode)
					                                     callback();
					                             else if(!/^[a-zA-Z][a-zA-Z0-9]{2,19}$/.test(value))
                                                                             callback(new Error("*用户名长度3 - 20，且只能包含字母或数字，不能以数字开头"));
					                             else if(await  this.$http({ method:"post",  url:"/user/valid_name",  data:{ user_name:value } }))
                                                                             callback(new Error("*用户名已存在"));
					                             else
                                                                             callback();
					                     },
						             trigger:"blur"
					             }
				             ],
				             user_pwd:[
                                                     { required: true, message: '* 密码不能为空', trigger: 'blur' },
                                                     { min: 3, max: 20, message: '* 密码长度3 - 20', trigger: 'blur' }
				             ],
			                }
		                },
	                };
		},
		computed: {
	               ...mapState({"roleList":"list"}),
		},
		created(){
	                //this.$store.dispatch("role/init");//初始化数据
			this.roleInit();//初始化数据角色
                        this.getData();
		},
		methods:{
			...mapActions({"roleInit":"init"}),
		        //发送初始数据 获得ajax    fromPage1  :是否需要页面重置
			async getData(fromPage1 = true) {
			        //判断是否需要从第一个开始看
			        if(fromPage1 ) this.pagination.currentPage = 1;
			        let {list,total} =  await this.$http({
				        url:"/user/list",
				        method:"post",
				        data: {
					        ...this.search,
					        begin:this.pagination.pageSize * (this.pagination.currentPage-1),//当前持有的条数
					        pageSize:this.pagination.pageSize
				        }
			        });
			      this.users = list;
			      this.pagination.total = total;
			},
                     /*   //查询的时候 搜索框 和下拉列表
                        searchChangeHandler(){
                                this.pagination.currentPage = 1;//换一批数据表示还是从第一页开始看
	                        this.getData();
                        },*/
			//分页控件
//                        indexMethod(index){//获取用户个数
//                                return index+1;
//                        },
                      /*  handleSizeChange() {//页码发生变化时 无论在第几页 都是要从第一页再从新开始
                                this.pagination.currentPage = 1;//换一批数据表示还是从第一页开始看
                                this.getData();
                        },
                        handleCurrentChange() {
	                        this.getData();
                        },*/
			//删除用户
			remove(user_name){
                              this.$confirm(`您确定要删除用户："${user_name}" ？`,"提示",{type:"warning"})
	                              .then(async () => {
	                                      await this.$http({
		                                      url:"/user/remove/"+user_name,
		                                      method:"post"
	                                      });
	                                      let i = this.users.findIndex(item => item.user_name === user_name);
	                                      this.users.splice(i,1);
	                                     this. pagination.total  -= 1;
	                                      this.$message({
		                                      message:`用户："${user_name}"，删除成功！`,
		                                      type:"success"
	                                      });
	                              })
	                              .catch(() => {});
			},
			//新增
			beginAdd() {
				this.$refs.form && this.$refs.form.resetFields();
                                this.edit.model.user_name = "";
	                        this.edit.model.use_pwd= "";
	                        this.edit.model.role_id = null;
			        this.edit.mode = true;
				this.edit.isEdit = true;
			},
			//修改
			beginUpdate(user) {
			       //console.log(users);
			        this.$refs.form && this.$refs.form.resetFields();
                                this.edit.model.user_name = user.user_name;
                                this.edit.model.user_pwd = user.user_pwd;
                                this.edit.model.role_id = user.role_id;
			        this.edit.mode = false;
			        this.edit.isEdit = true;
			},
                        formValidateHandler(prop,valid,message){
			        //判断刚刚验证的是不是username
	                        if(prop === "user_name") this.userNameValidateResult = valid;
                        },
			//保存
			async save() {
                                if(this.edit.mode) {
                                        if(this.userNameValidateResult === false) return;
                                        if(typeof this.userNameValidateResult === "undefined") {
                                                await new Promise(resolve => this.$refs.form.validateField("user_name", message => {
                                                        if(message === "") resolve();
                                                }));
                                        }
                                }
                                await  new Promise(resolve => this.$refs.form.validateField("user_pwd", message => {
                                        if(message === "") resolve();
                                }));
                                //代码能执行到这里，说明用户名和密码都通过了验证，可以执行后续真正的新增与修改操作了
			             if(this.edit.mode){
			                     await this.$http({
				                     url:"/user/add",
				                     method:"post",
				                     data:this.edit.model
			                     });
			                     this.users.push(Object.assign({},this.edit.model));
			                     this. pagination.total +=1;
			                     this.$message({
                                                     message:`${this.edit.model.user_name} 节点，新增成功！`  ,
                                                     type:"success"
			                     });
			             }else{
			                     await this.$http({
				                     url:"/user/change_pwd",
				                     method:"post",
				                     data:this.edit.model
			                     });
                                             let i = this.users.findIndex(item => item.user_name === this.edit.model.user_name);
                                             this.users.splice(i,1,Object.assign({},this.edit.model));
                                             this.$message({
                                                     message:`${this.edit.model.user_name} 节点，修改成功！`  ,
                                                     type:"success"
                                             });
			             }
			             this.edit.isEdit = false;
			},
			//点击分配按钮开始分配
                        beginRoleFuncConfig(user){
                                this.edit.model.user_name = user.user_name;
                                this.edit.model.role_id = user.role_id || 0;
                        },
                        async roleFuncConfig() {//分配角色
	                        if(this.edit.model)
                                await this.$http({
                                        url:"/user/config_role",
                                        method:"post",
                                        data:this.edit.model
                                });
	                        //从数组中找到当前修改的用户名
                                let target = this.users.find(item => item.user_name === this.edit.model.user_name);
                                target.role_id = this.edit.model.role_id || null;//判断是否有分配的id
                                this.$message({
	                                message:`用户：${this.edit.model.user_name},角色分配成功！`,
	                                type:"success"
                                });
                        },
			},
			watch:{
		                'edit.isEdit'(newValue) {
		                if(newValue === false) delete this.userNameValidateResult;
		         }
		}
	};
</script>

<style lang="stylus" type="text/stylus" scoped>
	.el-container
		position:absolute
		left :0
		top: 0
		height: 100%
		width:100%
		.el-main
			border-top:1px solid #b0b0b0
			border-bottom:1px solid #b0b0b0
			span.norole
				color:#b0b0b0
		.el-footer
			display:flex
			align-items:center
			.el-pagination
				flex-grow:1
</style>