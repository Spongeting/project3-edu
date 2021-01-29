<template>
	<div>
		<el-container>
			<el-header>
				<!--表单-->
				<el-form :inline="true">
					<el-form-item label="员工名字：">
						<el-input v-model.trim="search.stf_name"
						clearable prefix-icon="el-icon-search"
						placeholder="请输入搜索内容"
						@change="getData()"></el-input>
					</el-form-item>
					<el-form-item label="员工类型：">
						<el-select v-model="search.stf_category" @change="getData()" >
							<el-option label=" - 所有类型-" :value="0"></el-option>
							<el-option
							v-for="item in staffCategorylist"
							:key="item.dic_id"
							:label="item.dic_name"
							:value="item.dic_id"></el-option>
						</el-select>
					</el-form-item>
					<el-form-item>
						<el-button type="success" @click="beginAdd">+新增</el-button>
					</el-form-item>
				</el-form>
			</el-header>
			<el-main>
				<el-table :data="staffList" stripe border style="width: 100%">
					<el-table-column label="#" width="80" align="center" type="index"></el-table-column>
					<el-table-column label="姓名" prop="stf_name" width="180" align="center"></el-table-column>
					<el-table-column label="职务类型"  width="180" align="center">
						<template slot-scope="{row}">
							<span v-if="row.stf_category !== 0" v-text="staffCategorylist.find(item =>item.dic_id === row.stf_category).dic_name"></span>
						</template>
					</el-table-column>
					<el-table-column label="备注" prop="stf_remark" width="300"></el-table-column>
					<el-table-column label="员工状态" width="200" align="center">
						<template slot-scope="{row}">
							<span v-show="row.stf_invalid ==1 ">在职</span>
							<span v-show="row.stf_invalid ==0 " class="Resign">离职</span>
						</template>
					</el-table-column>
					<el-table-column label="操作">
						<template slot-scope="{row}">
							<el-button type="primary" @click="beginUpdate(row)">编辑</el-button>
							<el-button type="danger" v-show="row.stf_invalid == 1" @click="staffInvalidHandler(row)">离职</el-button>
							<el-button type="warning" v-show="row.stf_invalid == 0" @click="staffInvalidHandler(row)">入职</el-button>
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
		<el-dialog :modal="false" :visible="edit.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false" width="600px">
			<h3 slot="title" v-text="`员工编辑 - ${edit.mode ? '新增' : '修改'}`"></h3>
			<el-form label-width="100px" :model="edit.model" :rules="edit.rules" ref="form" status-icon>
				<el-form-item label="*员工名字：" prop="stf_name">
					<el-input v-model.trim="edit.model.stf_name" placeholder="请输入员工的名字"></el-input>
				</el-form-item>
				<el-form-item label="员工类型：" prop="stf_category">
					<el-select v-model="edit.model.stf_category">
						<el-option label=" - 所有类型-" :value="0"></el-option>
						<el-option
							v-for="item in staffCategorylist"
							:key="item.dic_id"
							:label="item.dic_name"
							:value="item.dic_id">
						</el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="员工备注：">
					<el-input type="textarea" placeholder="请输入内容" v-model="edit.model.stf_remark"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit.isEdit=false">取消</el-button>
				<el-button type="primary" @click="save">确定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script type="text/ecmascript-6">
import {createNamespacedHelpers} from 'vuex';
let{mapState:mapStateFromDirctionary} = createNamespacedHelpers('dictionary');

        export default {
                name:"Staff",
	        data() {
                        return {
                                staffList:[],//存放初始数据
	                        search:{
                                        stf_name:"",
		                        stf_category:0,
	                        },
	                        pagination:{
                                        total:0,
		                        pageSize:6,
		                        currentPage:1
	                        },
	                        edit:{
                                        isEdit:false,//是否进入编辑状态
		                        mode:true,//true新增false修改
		                        model:{
                                                stf_id:0,
                                                stf_name:"",
                                                stf_category:0,
                                                stf_remark:"",
			                        stf_invalid:1
		                        },
		                        rules:{
                                                stf_name:[
	                                                {
	                                                        validator:async(rule,value,callback) =>{
	                                                                let {stf_id,stf_name} = this.edit.model;
	                                                                if(value.length === 0)
	                                                                        callback(new Error('*员工姓名不能为空'));
	                                                                else if(value.length <2 || value.length > 20)
	                                                                        callback(new Error('*姓名长度 2 - 20'));
		                                                        else if(this.staffList.some(item =>item.stf_id !== stf_id && item.stf_name === stf_name ))
		                                                                callback(new Error('*员工姓名已存在！'));
		                                                        else
		                                                                callback();
	                                                        },
		                                                trigger:"blur"
	                                                }
                                                ],
			                        stf_category:[
				                        {
				                                validator:(rules,value,callback) => {
				                                        if(value === 0)
				                                                callback(new Error('*员工类型不能为空！'));
					                                else
					                                        callback();
				                                },
					                        trigger:"blur"
				                        }
			                        ]
		                        },
	                        },
                        };
	        },
	        computed:{
		        ...mapStateFromDirctionary(["staffCategorylist"]),
	        },
	        created() {
                        this.getData();
	        },
	        methods:{
		        //获取初始数据
		        async getData(fromPage1 = true) {
		                //传参  是否需要页面重置
			        if(fromPage1) this.pagination.currentPage = 1;
			        let {list,total} = await this.$http({
				        url:"/staff/list",
				        method:"post",
				        data:{
					        ...this.search,
					        begin:this.pagination.pageSize * (this.pagination.currentPage-1),
					        pageSize:this.pagination.pageSize
				        }
			        });
			      this.staffList = list;
			      this.pagination.total = total;
		        },
		        beginAdd(){
		                this.$refs.form && this.$refs.form.resetFields();
		                this.edit.model. stf_id = 0;
		                this.edit.model.stf_name = "";
                                this.edit.model.stf_category = 0;
                                this.edit.model.stf_remark = "";
		                this.edit.mode = true;
		                this.edit.isEdit = true;
		        },
		        beginUpdate(staff){
                                this.$refs.form && this.$refs.form.resetFields();
                                this.edit.model.stf_id = staff.stf_id;
                                this.edit.model.stf_name = staff.stf_name;
                                this.edit.model.stf_category = staff.stf_category;
                                this.edit.model.stf_remark = staff.stf_remark;
		                this.edit.mode = false;
		                this.edit.isEdit = true;
		        },
		        save(){
                                this.$refs.form.validate(async valid => {
		                        if(!valid) return;
                                        if(this.edit.mode){//新增
                                                await this.$http({
                                                        url:"/staff/add",
                                                        method:"post",
                                                        data:this.edit.model
                                                });
                                                this.staffList.push(Object.assign({},this.edit.model));
                                                this.pagination.total += 1;
                                                this.$message({
                                                        message:`${this.edit.model.stf_name}员工，新增成功！`,
                                                        type:"success"
                                                });
                                        }else{//修改
                                                await this.$http({
                                                        url:"/staff/update",
                                                        method:"post",
                                                        data:this.edit.model
                                                });
                                                let i = this.staffList.findIndex(item =>item.stf_id === this.edit.model.stf_id);
                                                this.staffList.splice(i,1,Object.assign({},this.edit.model));
                                                this.$message({
                                                        message:`${this.edit.model.stf_name}员工，修改成功！`,
                                                        type:"success"
                                                });
                                        }
                                        this.edit.isEdit = false;
		                });
		        },
		        staffInvalidHandler(node) {
		                if(node.stf_invalid === 1){
                                        this.$confirm(`确定让"${node.stf_name} 离职吗?"`,"提示",{type:"warning"})
                                                .then(async () => {
                                                        await this.$http({ url:"/staff/dimission/"+node.stf_id });
                                                        node.stf_invalid = 0;
	                                                this.$message({
		                                                message:`${node.stf_name} 员工， 离职成功！ `,
		                                                type:"success"
	                                                });
                                                })
                                                .catch(() => {});
		                }
		                else if(node.stf_invalid === 0){
                                        this.$confirm(`确定让"${node.stf_name} 入职吗?"`,"提示",{type:"warning"})
                                                .then(async () => {
                                                        await this.$http({ url:"/staff/reinstate/"+node.stf_id});
                                                        node.stf_invalid = 1;
                                                        this.$message({
                                                                message:`${node.stf_name} 员工， 入职成功！ `,
                                                                type:"success"
                                                        });
                                                })
                                                .catch(() => {});
		                }
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