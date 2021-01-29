<template>
	<div>
		<el-container>
			<!--表单-->
			<el-header>
				<el-form :inline="true">
					<el-form-item label="班级名称：">
						<el-input clearable v-model.trim="search.cls_name"
						          prefix-icon="el-icon-search"
						          placeholder="请输入搜索内容"
							@change="getData()">
						</el-input>
					</el-form-item>
					<el-form-item label="班级专业：">
						<el-select  v-model="search.cls_dic_id_major" @change="getData()">
							<el-option label=" - 所有专业 -" :value="0"></el-option>
							<el-option
							v-for="item in classMajorlist"
							:item="item.dic_id"
							:label="item.dic_name"
							:value="item.dic_id"></el-option>
						</el-select>
					</el-form-item>
					<el-form-item label="班级状态：" >
						<el-select v-model="search.cls_status" @change="getData()">
							<el-option label="- 所有 -" :value="0"></el-option>
							<el-option label="开课中" :value="1"></el-option>
							<el-option label="未开课" :value="2"></el-option>
							<el-option label="结课" :value="3"></el-option>
						</el-select>
					</el-form-item>
					<el-form-item>
						<el-button type="success" @click="beginAdd">+新增</el-button>
					</el-form-item>
				</el-form>
			</el-header>
			<!--表格-->
			<el-main>
				<el-table :data="classList" stripe border  style="width:100%">
					<el-table-column fixed label="#" width="80" align="center" type="index"></el-table-column>
					<el-table-column label="班级名称" width="120" align="center" prop="cls_name"></el-table-column>
					<el-table-column label="班级专业" width="120" align="center">
						<template slot-scope="{row}">
							<span v-if="row.cls_dic_id_major !==0" v-text="classMajorlist.find(item =>item.dic_id === row.cls_dic_id_major).dic_name"></span>
						</template>
					</el-table-column>
					<el-table-column label="教学老师" width="100" align="center" prop="cls_stf_id_teacher">
						<template slot-scope="{row}">
							<span v-if="teacherList.length > 0" v-text="teacherList.find(item => item.stf_id === row.cls_stf_id_teacher).stf_name"></span>
						</template>
					</el-table-column>
					<el-table-column label="教务老师" width="100" align="center" prop="cls_stf_id_admin">
						<template slot-scope="{row}">
							<span v-if="adminList.length > 0" v-text="adminList.find(item => item.stf_id === row.cls_stf_id_admin).stf_name"></span>
						</template>
					</el-table-column>
					<el-table-column label="就业老师" width="100" align="center" prop="cls_stf_id_job">
						<template slot-scope="{row}">
							<span v-if="jobList.length > 0" v-text="jobList.find(item => item.stf_id === row.cls_stf_id_job).stf_name"></span>
						</template>
					</el-table-column>
					<el-table-column label="教室" width="100" align="center" >
						<template slot-scope="{row}">
							<span v-if="row.cls_clsr_id !==null && list.length > 0" v-text="list.find(item => item.clsr_id === row.cls_clsr_id).clsr_name"></span>
						</template>
					</el-table-column>
					<el-table-column label="开课时间" width="140" align="center" prop="cls_begin"></el-table-column>
					<el-table-column label="结课时间" width="140" align="center" prop="cls_end"></el-table-column>
					<el-table-column label="班级状态" width="100" align="center" >
						<template slot-scope="{row}">
							<span v-if="row.cls_begin === null">未开课</span>
							<span v-else-if="row.cls_end === null">开课中</span>
							<span v-else>结课</span>
						</template>
					</el-table-column>
					<el-table-column label="备注" width="140" align="center">
						<template slot-scope="{row}">
							<span v-text="row.cls_remark === null ? '- 暂无备注 -' : `${row.cls_remark}` "></span>
						</template>
					</el-table-column>
					<el-table-column fixed="right" label="操作" width="240" align="center">
						<template slot-scope="{row}">
							<el-button type="primary"  size="mini" icon="el-icon-edit-outline" @click="beginUpdate(row)">修改</el-button>
							<el-button type="success" size="mini" v-if="row.cls_begin === null && row.cls_end === null" @click="beginClass(row)">开课</el-button>
							<el-button type="danger" size="mini" v-else-if="row.cls_begin !==null && row.cls_end === null " @click="endClass(row)">结课</el-button>
						</template>
					</el-table-column>
				</el-table>
			</el-main>
			<!--分页器-->
			<el-footer>
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
		<!--弹层1-->
		<el-dialog :modal="false" :visible="edit.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false" width="600px">
			<h3 slot="title" v-text="`班级管理 - ${edit.mode ? '新增' : '修改'}`"></h3>
			<el-form label-width="100px" :model="edit.model" :rules="edit.rules" ref="form" status-icon @validate="formValidateHandler">
				<el-form-item label="班级名称：" prop="cls_name">
					<el-input v-model="edit.model.cls_name" placeholder="请输入班级名称"></el-input>
				</el-form-item>
				<el-form-item label="*班级专业：" prop="cls_dic_id_major">
					<el-select v-model="edit.model.cls_dic_id_major">
						<el-option label=" - 请选择 - " :value="0"></el-option>
						<el-option
						v-for="item in classMajorlist"
						:item="item.dic_id"
						:label="item.dic_name"
						:value="item.dic_id">
						</el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="*教学老师：" prop="cls_stf_id_teacher">
					<el-select v-model="edit.model.cls_stf_id_teacher">
						<el-option label=" - 请选择 - " :value="0"></el-option>
						<el-option
							v-for="item in teacherList"
							:item="item.stf_id"
							:label="item.stf_name"
							:value="item.stf_id"
							:disabled="!item.stf_invalid ">
						</el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="*教务老师：" prop="cls_stf_id_admin">
					<el-select v-model="edit.model.cls_stf_id_admin">
						<el-option label=" - 请选择 - " :value="0"></el-option>
						<el-option
							v-for="item in adminList"
							:item="item.stf_id"
							:label="item.stf_name"
							:value="item.stf_id"
							:disabled="!item.stf_invalid">
						</el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="*就业老师：" prop="cls_stf_id_job">
					<el-select v-model="edit.model.cls_stf_id_job">
						<el-option label=" - 请选择 - " :value="0"></el-option>
						<el-option
							v-for="item in jobList"
							:item="item.stf_id"
							:label="item.stf_name"
							:value="item.stf_id"
							:disabled="!item.stf_invalid">
						</el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="班级备注：">
					<el-input type="textarea" placeholder="请输入内容" v-model="edit.model.cls_remark"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit.isEdit=false">取消</el-button>
				<el-button type="primary" @click="save">确定</el-button>
			</div>
		</el-dialog>
		<!--弹层2-->
		<el-dialog v-show="" :modal="false" :visible="edit2.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false" width="600px">
			<h3 slot="title">开班</h3>
			<el-form label-width="100px" :model="edit2.model" :rules="edit2.rules" ref="forms" status-icon>
				<el-form-item label="*教室：" prop="cls_clsr_id">
					<el-select v-model="edit2.model.cls_clsr_id">
						<el-option
						v-for="item in list"
						:key="item.clsr_id"
						:label="item.clsr_name"
						:value="item.clsr_id"
						:disabled="item.clsr_occupy === 1"></el-option>
					</el-select>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit2.isEdit=false">取消</el-button>
				<el-button type="primary" @click="saves">确定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script type="text/ecmascript-6">
        import {createNamespacedHelpers} from 'vuex';
        let{mapState:mapStateFromDirctionary} = createNamespacedHelpers('dictionary');
        let{mapState:mapStateFromClassroom,mapActions:mapActionsFromClassroom} = createNamespacedHelpers('classroom');

        export default {
                name:"Class",
	        data() {
                        return {
                                classList:[],//初始数据
                                teacherList:[],
	                        adminList:[],
	                        jobList:[],
	                        search:{
                                        cls_name:"",
                                        cls_dic_id_major:0,
                                        cls_status:0,
		                        cls_clsr_id:null
	                        },
	                        pagination:{
                                        total:0,
		                        pageSize:5,
		                        currentPage:1
	                        },
	                        edit:{
                                        isEdit:false,//是否进入编辑状态
		                        ismode:true,//true:新增 false：修改
		                        model:{
                                                cls_name:"",
			                        cls_dic_id_major:0,
			                        cls_stf_id_teacher:0,
			                        cls_stf_id_admin:0,
			                        cls_stf_id_job:0,
			                        cls_remark:"",
                                                cls_clsr_id:null,//班级教室id
                                                cls_id:0,//教室的id
                                                cls_begin:null,
                                                cls_end:null
		                        },
		                        rules:{
                                                cls_name:[
	                                                {
	                                                        validator:async(rules,value,callback) =>{
                                                                        if(!/^[a-zA-Z0-9][a-zA-Z0-9]{2,19}$/.test(value))
                                                                                callback(new Error("*班级名称长度3 - 20，且只能包含字母或数字"));
                                                                        else if(value.length === 0)
                                                                                callback(new Error("* 班级名称不能为空！"));
                                                                        else if(await  this.$http({ method:"post",  url:"/class/valid_name",  data:{ cls_name:value } })){
                                                                                //判断班级名称的验证结果  新增编辑都要判断
                                                                                let i = this.classList.findIndex(item => item.cls_name === this.edit.model.cls_name && item.cls_id !== this.edit.model.cls_id);
                                                                                if(i !== -1){
                                                                                        callback(new Error("*班级名称已存在"));
                                                                                }else{
                                                                                        callback();
                                                                                }
                                                                        }
                                                                        else
                                                                                callback();
	                                                        },
		                                                trigger:"blur"
	                                                }
                                                ],
                                                cls_dic_id_major:[
                                                        {
                                                                validator:(rules,value,callback) => {
                                                                        console.log(value);
                                                                        if(value === 0)
                                                                                callback(new Error('*班级专业不能为空！'));
                                                                        else
                                                                                callback();
                                                                },
                                                                trigger:"blur"
                                                        }
                                                ],
                                                cls_stf_id_teacher:[
                                                        {
                                                                validator:(rules,value,callback) => {
                                                                        if(value === 0)
                                                                                callback(new Error('*教学老师不能为空！'));
                                                                        else
                                                                                callback();
                                                                },
                                                                trigger:"blur"
                                                        }
                                                ],
                                                cls_stf_id_admin:[
                                                        {
                                                                validator:(rules,value,callback) => {
                                                                        if(value === 0)
                                                                                callback(new Error('*教务老师不能为空！'));
                                                                        else
                                                                                callback();
                                                                },
                                                                trigger:"blur"
                                                        }
                                                ],
                                                cls_stf_id_job:[
                                                        {
                                                                validator:async(rules,value,callback) => {
                                                                        if(value === 0)
                                                                                callback(new Error('*就业老师不能为空！'));
                                                                        else
                                                                                callback();
                                                                },
                                                                trigger:"blur"
                                                        }
                                                ]
		                        }
	                        },
	                        edit2:{
                                        isEdit:false,
		                        model:{
                                                cls_id:0,
                                                cls_clsr_id:null,
		                        },
		                        rules:{
                                                cls_clsr_id:[
                                                        {
                                                                validator:(rules,value,callback) => {
                                                                        if(value === null)
                                                                                callback(new Error('*开班教室不能为空！'));
                                                                        else
                                                                                callback();
                                                                },
                                                                trigger:"blur"
                                                        }
                                                ]
		                        }
	                        }
                        };
	        },
	        computed:{
		        ...mapStateFromDirctionary(["classMajorlist","staffCategorylist"]),
		        ...mapStateFromClassroom(["list"])
	        },
	       created(){
                        this.init();
                        this.getData();
                        this.getstaff();
	        },
	        methods:{
		        ...mapActionsFromClassroom(["init"]),
	            //获取初始数据
		        async getData(fromPage1 = true){
		                if(fromPage1) this.pagination.currentPage = 1;
			        let {list,total} = await this.$http({
			                url:"/class/list",
			                method:"post",
			                data:{
                                                ...this.search,
                                                begin:this.pagination.pageSize * (this.pagination.currentPage-1),//当前持有的条数
                                                pageSize:this.pagination.pageSize
			                }
		                 });
		                this.classList = list;
		                console.log( this.classList);
		                this.pagination.total = total;
		        },
		        getstaff(){//获取不同类别的员工
                                this.$http({ url:"/staff/listbycategory/"+4 })
	                                .then(data =>{this.teacherList  = data});
                                this.$http({ url:"/staff/listbycategory/"+5 })
	                                .then(data =>{this.adminList =  data});
                                this.$http({ url:"/staff/listbycategory/"+6 })
	                                .then(data =>{this.jobList = data});
		        },
		        beginAdd(){
		                this.$refs.form && this.$refs.form.resetFields();
		                this.edit.model.cls_name = "";
                                this.edit.model.cls_dic_id_major = 0;
                                this.edit.model.cls_stf_id_teacher = 0;
                                this.edit.model.cls_stf_id_admin = 0;
                                this.edit.model.cls_stf_id_job = 0;
                                this.edit.model.cls_remark = "";
                                this.edit.model.cls_id = 0;
                                this.edit.model.cls_clsr_id = null;
                                this.edit.model.cls_begin =null;
			        this.edit.model.cls_end = null;
                                this.edit.mode= true;
		                this.edit.isEdit = true;
		        },
		        beginUpdate(node){
		                this.$refs.form && this.$refs.form.resetFields();
                               this.edit.model.cls_name = node.cls_name;
                                this.edit.model.cls_dic_id_major = node.cls_dic_id_major;
                                this.edit.model.cls_stf_id_teacher = node.cls_stf_id_teacher;
                                this.edit.model.cls_stf_id_admin = node.cls_stf_id_admin;
                                this.edit.model.cls_stf_id_job = node.cls_stf_id_job;
                                this.edit.model.cls_remark = node.cls_remark;
                                this.edit.model.cls_clsr_id = node.cls_clsr_id;
                                this.edit.model.cls_id = node.cls_id;
                                this.edit.model.cls_begin =node.cls_begin;
                                this.edit.model.cls_end = node.cls_end;
		                this.edit.mode = false;
                                this.edit.isEdit = true;
		        },
                        formValidateHandler(prop,valid,message){
                                //判断刚刚验证的是不是username
                                if(prop === "cls_name") this.userNameValidateResult = valid;
                        },
		        async save(){
                                if(this.edit.mode) {
                                        if(this.userNameValidateResult === false) return;
                                        if(typeof this.userNameValidateResult === "undefined") {
                                                await new Promise(resolve => this.$refs.form.validateField("cls_name", message => {
                                                        if(message === "") resolve();
                                                }));
                                        }
                                }
                                let arr  = ["cls_dic_id_major", "cls_stf_id_teacher","cls_stf_id_admin","cls_stf_id_job"];
                                await Promise.all(arr.map(item => {
                                        return new Promise(resolve => this.$refs.form.validateField(item, message => {
                                                if(message === "") resolve();
                                        }))
                                }));

		                     if(this.edit.mode){
		                            this.edit.model.cls_id =  await this.$http({
			                             url:"/class/add",
			                             method:"post",
			                             data:this.edit.model
		                             });
		                             this.classList.push(Object.assign({},this.edit.model));
		                             this.pagination.total += 1;
		                             this.$message({
			                             message:`${this.edit.model.cls_name}班级，新增成功！`,
			                             type:"success"
		                             });
		                     }else{
		                             await this.$http({
			                             url:"/class/update",
			                             method:"post",
			                             data:this.edit.model
		                             });
		                             let i = this.classList.findIndex(item => item.cls_id === this.edit.model.cls_id);
		                              this.classList.splice(i,1,Object.assign({},this.edit.model));
		                              this.$message({
                                                      message:`${this.edit.model.cls_name}班级，修改成功！`,
                                                      type:"success"
		                              });
		                     }
		                     this.edit.isEdit = false;
		        },
		        //弹层2
                        beginClass(node) {
		                this.$confirm(`您确定要对"${node.cls_name}"开课吗？`,"提示",{type:"warning"})
			                .then(() => {
                                                //准备工作
                                                this.$refs.form && this.$refs.form.resetFields();
                                                this.edit2.model.cls_id = node.cls_id;
                                                this.edit2.model.cls_clsr_id = node.cls_clsr_id;
                                                this.edit2.isEdit = true;
			                })
			                .catch(() => {});
                        },
		        endClass(node) {
		                this.$confirm("您确定要结课吗","提示",{type:"warning"})
			                .then(async () => {
			                      let result =  await this.$http({
				                      url:"/class/end",
				                      method:"post",
				                      data:this.edit2.model
			                      });
			                      //修改数组中的数据
				                this.classList.find(item => item.cls_id === node.cls_id).cls_end = result;
			                        this.$message({
				                        message:"结课成功！",
				                        type:"success"
			                        });
			                } )
			                .catch(() =>{});
		        },
		        saves() {//开课
			        this.$refs.forms.validate(async valid => {
			                if(!valid) return;
                                        let result = await this.$http({
                                                url:"/class/begin",
                                                method:"post",
                                                data:this.edit2.model
                                        });
                                        //修改数组中的数据
                                        this.classList.find(item => item.cls_id === this.edit2.model.cls_id).cls_begin = result;
                                        this.classList.find(item => item.cls_id === this.edit2.model.cls_id).cls_clsr_id = this.edit2.model.cls_clsr_id;
                                        this.$message({
                                                message:"开课成功",
                                                type:"success"
                                        });
                                        this.edit2.isEdit = false;
			        });
		        }
	        },
                watch: {
                        'edit.isEdit'(newValue){
                                if(newValue === false) delete this.userNameValidateResult;
                        }
                }
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>
	.el-container
		position:absolute
		left :0
		top: 0
		height: 100%
		width:100%
		.el-main
			border-top:1px solid #b0b0b0
			border-bottom:1px solid #b0b0b0
			span.Resign
				color:red
		.el-footer
			display:flex
			align-items:center
			.el-pagination
				flex-grow:1
</style>