<template>
	<div>
		<el-container>
			<el-header>
				<!--表单-->
				<el-form :inline="true">
					<el-form-item label="学生名字：">
						<el-input
							v-model.trim="search.stu_name"
							clearable prefix-icon="el-icon-search"
							placeholder="请输入搜索内容"
							@change="getData()"></el-input>
					</el-form-item>
					<el-form-item label="所在班级：">
						<el-select v-model="search.stu_cls_id" @change="getData()">
							<el-option label=" - 全部 - " :value="0"></el-option>
							<el-option
								v-for="item in clsList"
								:item="item.cls_id"
								:label="item.cls_name"
								:value="item.cls_id">
							</el-option>
						</el-select>
					</el-form-item>
					<el-form-item label="学生学历：">
						<el-select v-model="search.stu_qualification" @change="getData()">
							<el-option label=" - 全部 - " :value="0"></el-option>
							<el-option
								v-for="item in qualificationlist"
								:item="item.dic_id"
								:label="item.dic_name"
								:value="item.dic_id">
							</el-option>
						</el-select>
					</el-form-item>
					<el-form-item>
						<el-button type="primary" @click="beginAdd">+新增</el-button>
					</el-form-item>
					<el-form-item>
						<el-button type="success" icon="el-icon-share" @click="beginMoreGroup">批量分班</el-button>
					</el-form-item>
					<el-form-item>
						<el-button type="danger" icon="el-icon-download">导出学生信息</el-button>
					</el-form-item>
				</el-form>
			</el-header>
			<el-main>
				<!--表格-->
				<el-table :data="stu" stripe border style="width: 100%"  @selection-change="handleSelectionChange">
					<el-table-column fixed label="#" width="80" align="center" type="index"></el-table-column>
					<el-table-column fixed type="selection" width="80" align="center"></el-table-column>
					<el-table-column fixed label="学生姓名" width="140" align="center" prop="stu_name"></el-table-column>
					<el-table-column label="班级" width="140" align="center">
						<template slot-scope="{row}">
							<span  v-text="row.stu_cls_id ? clsList.length > 0 && clsList.find(item=>item.cls_id === row.stu_cls_id).cls_name : '无班级'"></span>
						</template>
					</el-table-column>
					<el-table-column label="预览" width="140" align="center">
						<template slot-scope="{row}">
							<el-popover  placement="right" trigger="click">
								<el-button slot="reference"  type="text">预览</el-button>
								<div v-if="row.stu_avatar">
									<span v-text="`${row.stu_name}:`"></span>
									<el-image style="width:200px" :src="row.stu_avatar"></el-image>
								</div>
								<div v-else>暂无相关图片</div>
							</el-popover>
						</template>
					</el-table-column>
					<el-table-column label="性别" width="140" align="center">
						<template slot-scope="{row}">
							<span v-show="row.stu_sex === 1 ">男</span>
							<span v-show="row.stu_sex === 0">女</span>
						</template>
					</el-table-column>
					<el-table-column label="联系电话" width="140" align="center" prop="stu_phone"></el-table-column>
					<el-table-column label="联系电话(备用)" width="140" align="center" prop="stu_phone2"></el-table-column>
					<el-table-column label="出生日期" width="140" align="center" prop="stu_born"></el-table-column>
					<el-table-column label="学历" width="140" align="center">
						<template slot-scope="{row}">
							<span v-if="qualificationlist.length > 0" v-text="qualificationlist.find(item => item.dic_id === row.stu_qualification).dic_name"></span>
						</template>
					</el-table-column>
					<el-table-column label="毕业院校" width="140" align="center" prop="stu_school"></el-table-column>
					<el-table-column label="院校专业" width="140" align="center" prop="stu_major"></el-table-column>
					<el-table-column label="家庭住址" width="180" align="center" prop="stu_address"></el-table-column>
					<el-table-column label="备注" width="140" align="center" prop="stu_remark"></el-table-column>
					<el-table-column fixed="right" label="操作" width="400" align="center">
						<template slot-scope="{row}">
							<el-button type="success" size="mini" icon="el-icon-share" @click="beginGroup(row)">分班</el-button>
							<el-button type="danger" size="mini" icon="el-icon-picture-outline" @click="uploadImages(row)">照片存档</el-button>
							<el-button type="primary" size="mini" icon="el-icon-edit" @click="beginUpdate(row)">编辑</el-button>
							<el-button type="warning" size="mini" icon="el-icon-delete">删除</el-button>
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
		<!--弹层1-->
		<el-dialog :modal="false" :visible="edit.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false" width="600px">
			<h3 slot="title" v-text="`学生管理 - ${edit.mode ? '新增' : '修改'}`"></h3>
			<el-form label-width="120px" :model="edit.model" :rules="edit.rules" ref="form" status-icon @validate="formValidateHandler">
				<el-form-item label="*学生姓名：" prop="stu_name">
					<el-input v-model="edit.model.stu_name" placeholder="请输入学生姓名"></el-input>
				</el-form-item>
				<el-form-item label="性别：">
					<el-radio v-model="edit.model.stu_sex" :label="1">男</el-radio>
					<el-radio v-model="edit.model.stu_sex" :label="0">女</el-radio>
				</el-form-item>
				<el-form-item label="*联系电话：" prop="stu_phone">
					<el-input v-model="edit.model.stu_phone" placeholder="请输入手机号" maxlength="11" show-word-limit></el-input>
				</el-form-item>
				<el-form-item label="*备用电话：" prop="stu_phone2">
					<el-input v-model="edit.model.stu_phone2" placeholder="请输入备用联系电话(手机号/座机号)">
						<template slot="append">例如：028-88888888</template>
					</el-input>
				</el-form-item>
				<el-form-item label="*出生日期：" prop="stu_born">
					<el-col :span="11">
						<el-date-picker
							type="date"
							placeholder="选择日期"
							v-model="edit.model.stu_born"
							value-format="yyyy-MM-dd"
							:picker-options="edit.pickerOptions"></el-date-picker>
					</el-col>
				</el-form-item>
				<el-form-item label="*学历："  prop="stu_qualification">
					<el-select v-model="edit.model.stu_qualification" placeholder="- 请选择学生的学历 -">
						<el-option
							v-for="item in qualificationlist"
							:item="item.dic_id"
							:label="item.dic_name"
							:value="item.dic_id">
						</el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="在读/毕业院校：">
					<el-input v-model="edit.model.stu_school" placeholder="请输入在读/毕业的院校(选填)"></el-input>
				</el-form-item>
				<el-form-item label="在校学习专业：">
					<el-input v-model="edit.model.stu_major" placeholder="请输入在校学习专业(选填)"></el-input>
				</el-form-item>
				<el-form-item label="*家庭住址：" prop="stu_address">
					<el-input v-model="edit.model.stu_address" placeholder="请输入家庭地址"></el-input>
				</el-form-item>
				<el-form-item label="学生备注：">
					<el-input v-model="edit.model.stu_remark" type="textarea" placeholder="请输入学生备注。"></el-input>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit.isEdit=false">取消</el-button>
				<el-button type="primary" @click="save">确定</el-button>
			</div>
		</el-dialog>
		<!--弹层2-->
		<el-dialog :modal="false" :visible="upload.isUpload" :show-close="false" :close-on-click-modal="false" :close-on-press-escpae="false" width="600px" title="照片存档">
			<div v-show="upload.model.stu_avatar_old" class="oldPicture">
				<span slot="title">学生当前存档图片：</span>
				<el-image style="width:200px" :src="upload.model.stu_avatar_old"></el-image>
			</div>
			<el-upload ref="upload"
			           accept=".jpg,.png"
			           list-type="picture-card"
			           action="/student/avatarupload"
			           name="avatar"
			           :headers="uploadHeaders"
			           :before-upload="beforeAvatarUpload"
			           :on-success="avatarUploadSuccess"
			           :on-remove="avatarRemove">
				<i class="el-icon-plus"></i>
				<p slot="tip" class="tips">提示：只能上传jpg或png格式的文件，且大小不能超过2M</p>
			</el-upload>
			<div slot="footer">
				<el-button @click="upload.isUpload=false">取消</el-button>
				<el-button :disabled="upload.model.stu_avatar_new === ''" type="primary" @click="avatarUpload">存档</el-button>
			</div>
		</el-dialog>
		<!--弹层3-->
		<el-dialog :modal="false" :visible="edit2.isEdit" :show-close="false" :close-on-click-modal="false" :close-on-press-escpae="false" width="600px" title="分班">
			<el-form label-width="120px" :model="edit2.model">
				<el-form-item label="班级：">
					<el-select v-model="edit2.model.stu_cls_id">
						<el-option label=" - 无班级 - " :value="null"></el-option>
						<el-option
							v-for="item in clsList"
							:key="item.cls_id"
							:label="item.cls_name"
							:value="item.cls_id"
							:disabled="item.cls_end !== null "></el-option>
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
        export default {
                name:"Student",
	        data(){
                        return {
                                stu:[],//初始数据
	                        clsList:[],//所有班级的信息
	                        search:{
                                        stu_name:"",
		                        stu_cls_id:0,
		                        stu_qualification:0
	                        },
	                        pagination:{
                                        total:0,
		                        pageSize:5,
		                        currentPage:1
	                        },
	                        edit:{
                                        isEdit:false,
		                        ismode:true,
		                        model:{
                                                stu_id:0,
			                        stu_avatar:null,
			                        stu_cls_id:null,
                                                stu_name:"",
			                        stu_sex:1,
			                        stu_phone:"",
			                        stu_phone2:"",
			                        stu_born:"",
			                        stu_address:"",
                                                stu_qualification:null,
			                        stu_school:"",
			                        stu_major:"",
			                        stu_remark:""
		                        },
                                        pickerOptions:{
                                                disabledDate(time) {
                                                        return time.getTime() > Date.now() - 3600 *1000 * 24 * 365 * 18;
                                                }
		                        },
		                        rules:{
                                                stu_name:[
	                                                {
	                                                        validator:(rule,value,callback)=>{
	                                                                if(value.length === 0)
	                                                                        callback(new Error("*姓名必填！"));
		                                                        else if(value.length < 2 || value.length > 20)
		                                                                callback(new Error("*姓名长度2 - 20"));
		                                                        else
		                                                                callback();
	                                                        },
                                                                trigger:"blur"
	                                                }
                                                ],
                                                stu_phone:[
	                                                {
	                                                        validator:async (rule,value,callback)=>{
	                                                                if(value.length === 0)
	                                                                        callback(new Error("*联系方式必填！"));
	                                                                else if(await this.$http({//验证电话号码是否重复 返回0 不重复 返回1  重复
			                                                                url:"/student/valid_phone",
			                                                                method:"post",
			                                                                data:{stu_phone:value}
		                                                                }))
	                                                                        callback(new Error("*无效号码！"));
	                                                                //1.以1开头 2.第二位可以是3,4,5,7,8中的任意一位3.最后以0-9的9个整数结尾
	                                                                else if(!/^[1][3,4,5,7,8][0-9]{9}$/.test(value))
	                                                                        callback(new Error("*无效号码！"));
	                                                                else
	                                                                        callback();
	                                                        },
		                                                trigger:"blur"
	                                                }
                                                ],
                                                stu_phone2:[
                                                        {
                                                                validator:async (rule,value,callback)=>{
                                                                        if(value.length === 0)
                                                                                callback(new Error("*联系方式必填！"));
                                                                       /* else if(await this.$http({   没有备用的 两个学生共用一个备用电话
                                                                                        url:"/student/valid_phone",
                                                                                        method:"post",
                                                                                        data:{stu_phone:value}
                                                                                }))
                                                                                callback(new Error("*无效号码！"));*/
                                                                        else if(!/^[1][3,4,5,7,8][0-9]{9}$/.test(value))
                                                                                callback(new Error("*无效号码！"));
                                                                        else
                                                                                callback();
                                                                },
                                                                trigger:"blur"
                                                        }
                                                ],
                                                stu_born:[
	                                                {
	                                                        validator:(rule,value,callback)=>{
	                                                                if(value.length === 0)
	                                                                        callback(new Error("*出生日期必填！"));
	                                                                else
	                                                                        callback();
	                                                        },
		                                                trigger:"blur"
	                                                }
                                                ],
                                                stu_qualification:[//非空
                                                        {
                                                                validator:(rule,value,callback) => {
                                                                        if(value === null)
                                                                                callback(new Error('*学历必填！'));
                                                                        else
                                                                                callback();
                                                                },
                                                                trigger:"blur"
                                                        }
                                                ],
                                                stu_address:[//非空 长度
                                                          {
	                                                        validator:(rule,value,callback) =>{
	                                                                if(value.length === 0)
	                                                                        callback(new Error("*家庭地址必填！"));
	                                                                else if(value.length < 10 || value.length > 100)
	                                                                        callback(new Error("*长度为 10 - 100 "));
	                                                                else
	                                                                        callback();
	                                                        },
	                                                          trigger:"blur"
	                                                }
                                                ]
		                        }
	                        },
                                uploadHeaders:{"Authorization": sessionStorage.getItem("token")},
	                        upload:{//弹层2
		                        isUpload:false,//是否进入编辑状态
                                        model:{
                                                stu_id:0,
                                                stu_avatar_old:null,
                                                stu_avatar_new:""
                                        }
	                        },
	                        edit2:{
                                        isEdit:false,
		                        model:{
                                                stu_id:0,
			                        stu_ids:[],
			                        stu_cls_id:null
		                        },
		                        ids:[]
	                        }
                        };
	        },
                computed:{
	                ...mapStateFromDirctionary(["qualificationlist"])
                },
	        created() {
	                this.clsData();
	                this.getData();
	        },
	        methods:{
	                async clsData(){//获取班级的全部信息
		                this.clsList = await this.$http({ url:"/class/all"});
		              // console.log(this.clsList);
	                },
		        async getData(fromPage1 = true) {
	                        if(fromPage1) this.pagination.currentPage = 1;
	                        let {list,total} = await this.$http({
		                        url:"/student/list",
		                        method:"post",
		                        data:{
			                        ...this.search,
			                        begin:this.pagination.pageSize * (this.pagination.currentPage -1 ),
			                        pageSize:this.pagination.pageSize
		                        }
	                        });
	                        this.stu = list;
	                       // console.log(this.stu);
	                        this.pagination.total = total;

		        },
		       /* remove(node){
	                        this.$confirm(`您确定删除"${node.stu_name}"这个学生吗？`,"警告",{type:"warning"})
		                        .then(async () =>{
		                                await this.$http({
			                                url:"",
			                                method:"",
		                                });
		                                let i = this.stu.findIndex(item =>item.stu_id === node.stu_id);
		                                this.stu.splice(i,1);
		                                this.message({
			                                message:`${node.stu_name}学生，删除成功！`,
			                                type:"success"
		                                });
		                        })
		                        .catch(() =>{});
		        },*/
		       beginAdd(){
		               this.$refs.form && this.$refs.form.resetFields();
		               this.edit.mode = true;
		               this.edit.model.stu_id=0;
		               this.edit.model.stu_avatar=null;
		               this.edit.model.stu_cls_id=null;
                               this.edit.model.stu_name="";
                               this.edit.model.stu_sex = 1;
                               this.edit.model.stu_phone="";
                               this.edit.model.stu_phone2="";
                               this.edit.model.stu_born="";
                               this.edit.model.stu_address="";
                               this.edit.model.stu_qualification=null;
                               this.edit.model.stu_school="";
                               this.edit.model.stu_major="";
                               this.edit.model.stu_remark="";
		               this.edit.isEdit = true;
		       },
		        beginUpdate(node){
		               this.$refs.form && this.$refs.form.resetFields();
		               this.edit.mode = false;
                                this.edit.model.stu_id=node.stu_id;
                                this.edit.model.stu_avatar=node.stu_avatar;
                                this.edit.model.stu_cls_id=node.stu_cls_id;
                                this.edit.model.stu_name=node.stu_name;
                                this.edit.model.stu_sex = node.stu_sex;
                                this.edit.model.stu_phone=node.stu_phone;
                                this.edit.model.stu_phone2=node.stu_phone2;
                                this.edit.model.stu_born=node.stu_born;
                                this.edit.model.stu_address=node.stu_address;
                                this.edit.model.stu_qualification=node.stu_qualification;
                                this.edit.model.stu_school=node.stu_school;
                                this.edit.model.stu_major=node.stu_major;
                                this.edit.model.stu_remark=node.stu_remark;
		               this.edit.isEdit = true;
		        },
                        formValidateHandler(prop,valid,message){
                                //判断刚刚验证的是不是username
                                if(prop === "stu_phone") this.userNameValidateResult = valid;
                        },//表单验证 验证手机号码
		        async save(){
                                if(this.edit.mode) {
                                        if(this.userNameValidateResult === false) return;
                                        if(typeof this.userNameValidateResult === "undefined") {
                                                await new Promise(resolve => this.$refs.form.validateField("stu_phone", message => {
                                                        if(message === "") resolve();
                                                }));
                                        }
                                }
                                let arr  = ["stu_name","stu_phone2","stu_born","stu_qualification","stu_address"];
                                await Promise.all(arr.map(item => {
                                        return new Promise(resolve => this.$refs.form.validateField(item, message => {
                                                if(message === "") resolve();
                                        }))
                                }));

		                if(this.edit.mode){
		                        let result = await this.$http({
			                        url:"/student/add",
			                        method:"post",
			                        data:this.edit.model
		                        });
		                        console.log(result);
		                        this.stu.push(Object.assign({},this.edit.model));
		                        this.pagination.total += 1;
		                        this.$message({
			                        message:"新增成功！",
			                        type:"success"
		                        });
		                }else{
		                        await this.$http({
			                        url:"/student/update",
			                        method:"post",
			                        data:this.edit.model
		                        });
		                        let i = this.stu.findIndex(item =>item.stu_id === this.edit.model.stu_id);
		                        this.stu.splice(i,1,Object.assign({},this.edit.model));
		                        this.$message({
			                        message:"修改成功！",
			                        type:"success"
		                        });
		                }
		                this.edit.isEdit=false;
		        },
                        uploadImages(node) {
                                this.upload.model.stu_avatar_old = node.stu_avatar;//把旧的赋值给更旧的
		                this.upload.model.stu_id = node.stu_id;
		                this.upload.isUpload = true;
                        },
                        beforeAvatarUpload(file) {//开始上传 预上传
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
                        avatarUploadSuccess({status,data,message},file,fileList) {//上传更新之后
		                switch(status) {
			                case 200:
			                        this.upload.model.stu_avatar_new = data;
			                        if(fileList.length > 1) fileList.shift();
			                        break;
			                case 401:
			                        this.$message.warning("登录超时！");
                                                this.$router.replace('/login');
			                case 404:
			                case 199:
			                case 500:
			                        this.$message.error(message);
		                }
                        },
                        avatarRemove(file,fileList) {
		                this.upload.model.stu_avatar_new = "";
                        },//上传之后移除 保证头像只有一张
		        async avatarUpload() {//发送ajax
		                let url = await this.$http({
                                        method:"post",
                                        url:"/student/avatarupdate",
                                        data:this.upload.model
		                });
                                //把当前的赋值给旧的
		                this.upload.model.stu_avatar_old = url;
                                //提示用户上传成功 并且关闭对话框
                                this.$message.success("头像上传更新成功！");
                                //关闭上传头像对话框
                                this.upload.isUpload = false;
                                //重置上传控件 为下一次上传做准备
                                this.$refs.upload.clearFiles();
		        },
                        beginGroup(node) {//分班
		                this.edit2.model.stu_id = node.stu_id;
		                this.edit2.model.stu_cls_id=null;
		                this.edit2.model.stu_ids = [node.stu_id];
		                this.edit2.isEdit = true;
                        },
                        handleSelectionChange(rows) {//返回的是一个数组 判断数组的长度 >0
                                this.edit2.ids = [];
	                        if(rows.length > 0){
	                                rows.forEach(item => {
                                                this.edit2.ids .push(item.stu_id);
	                                })
	                        }/*else{
	                                this.edit2.model.stu_ids = [];
	                        }*/
	                       // console.log(this.edit2.model.stu_ids); ids数组内id重复出现 数组去重？？？
                        },
                        beginMoreGroup(){//批量分班
		                if(this.edit2.ids.length === 0){
		                      this.$alert("请勾选要分班的学生！","提示",{
                                              confirmButtonText: '确定'
		                      });
		                }else{
                                        this.edit2.model.stu_id = null;
                                        this.edit2.model.stu_cls_id=null;
                                        this.edit2.model.stu_ids = this.edit2.ids;
                                        this.edit2.isEdit = true;
		                }
                        },
		       async saves() {//分班
                                await this.$http({
	                                url:"/student/assignclass",
	                                method:"post",
	                                data:this.edit2.model
                                });
                                this.edit2.model.stu_ids.forEach(item =>{//ids分组遍历
                                        this.stu.find(item2 =>item2.stu_id === item).stu_cls_id = this.edit2.model.stu_cls_id;
                                });
                                this.$message.success("分班成功!");
                                this.edit2.isEdit = false;
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
	.tips
		color:red
		margin-top:10px
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
	.oldPicture
		margin-bottom:20px
</style>