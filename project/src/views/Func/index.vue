<template>
	<div>
		<!--&lt;!&ndash;测试 如何使用vux中的共用数据&ndash;&gt;
		<span v-text="$store.state.number"></span>
		<el-button @click="$store.commit('changeNumber',99)">点击按钮 改变数据</el-button>
		&lt;!&ndash;测试 子仓库中对数据的访问和修改&ndash;&gt;
		<span v-text="$store.state.func.number"></span>
		<el-button @click="$store.commit('func/changeNumber',999)">点击按钮 改变数据</el-button>-->
		<!--树形控件 静态->动态 -->
		<el-tree :data="treeData" default-expand-all class="custom-tree" :expand-on-click-node="false">
			<span class="custom-tree-node" slot-scope="{node,data}">
				<span v-text="data.func_name" :class="{ root: data.func_id === 0, unleaf:data.func_key === '', leaf: data.func_key !== '' }"></span>
				<span>
					<el-button type="text" v-if="data.func_key === '' "
						@click="beginAdd(data)">
						<i class="el-icon-plus"></i>
					</el-button>
					<el-button type="text" v-if="data.func_id !== 0"
						@click="beginUpdate(data)"><i class="el-icon-edit"></i></el-button>
					<el-button type="text" v-if="[0,44,45].indexOf(data.func_id) === -1" :disabled="typeof(data.children) !== 'undefined' "
							@click="remove(data)" >
						<i class="el-icon-delete"></i>
					</el-button>
				</span>
			</span>
		</el-tree>
		<!--dialog-->
		<el-dialog :modal="false" :visible ="edit.isEdit"  :show-close="false" :close-on-click-modal="false" :close-on-press-escape="false" width="600px" :title="edit.mode ? '功能管理- 新增' : '功能管理- 修改' " >
			<el-form label-width="140px" :model="edit.model" :rules="edit.rules" ref="form" >
				<!--节点类型-->
				<el-form-item label="系统功能类型:">
						<el-radio v-model="edit.isLeaf" :label="false"
						          :disabled="!(edit.mode && edit.model.func_fid === 0 ) ">非叶子功能节点</el-radio>
						<el-radio  v-model="edit.isLeaf" :label="true"
							:disabled="!(edit.mode && edit.model.func_fid === 0 ) ">叶子功能节点</el-radio>
				</el-form-item>
				<!--父节点 新增状态是禁用的 只有修改状态是可以使用的 label:下拉列表中每一项中的汉字 value：当前选中每一项的id的值-->
				<el-form-item label="父级节点名称:">
					<el-select v-model="edit.model.func_fid" :disabled="edit.mode || !edit.isLeaf">
						<el-option
							v-for="item in selectData"
							:key="item.value"
							:label="item.label"
							:value="item.value"
							></el-option>
					</el-select>
				</el-form-item>
				<el-form-item label="系统功能名称:" prop="func_name">
					<el-input v-model.trim =edit.model.func_name placeholder="请输入功能名称"></el-input>
				</el-form-item>
				<el-form-item label="系统功能关联组件:" v-show="edit.isLeaf " prop="func_key">
					<!--将对象中的所有键名取出来构成一个数组-->
					<el-select v-model="edit.model.func_key">
						<el-option
							v-for="item in Object.keys(views)"
							:key="item"
							:label="item"
							:value="item"
							:disabled="list.findIndex(func => func.func_key === item) !== -1"></el-option>
					</el-select>
				</el-form-item>
			</el-form>
			<div slot="footer">
				<el-button @click="edit.isEdit=false" >取消</el-button>
				<el-button type="primary"  @click="save">确定</el-button>
			</div>
		</el-dialog>
	</div>
</template>

<script type="text/ecmascript-6">
	import views from '../../views';
	import {createNamespacedHelpers} from 'vuex';//导入
	let {mapState,mapGetters, mapActions} = createNamespacedHelpers("func");//映射收到四个参数

        export default {
                name:"Func",
	        data() {
                        return {
                                views,
                                //funcs:[],
	                        edit:{//新增和修改所有相关的数据
		                        mode:true,//true表示新增 false表示修改 mode:模式
                                        isEdit:false,//是否显示弹窗 是否是编辑状态
		                        isLeaf:true,//是否是叶子节点
		                        model:{//编辑的模型
                                                func_id:0,
			                        func_name:"",
			                        func_key:"",
			                        func_fid:-1
		                        },
		                        rules:{
		                                func_name:[
		                                        //自定义验证规则
			                                {
			                                        validator:(rule,value, callback) => {
			                                                //es6中的解构赋值
				                                        let {func_id,func_name,func_fid} = this.edit.model;
			                                                if(value.length === 0)
			                                                        callback(new Error('*功能名称不能为空'));
			                                                else if(value.length < 2 || value.length > 50)
			                                                        callback(new Error('*功能名称长度2-50'));
				                                        else if(this.list.some(item => item.func_id !== func_id && item.func_name === func_name && item.func_fid === func_fid))
				                                                callback(new Error('* 功能名称在当前父级中已存在'));
			                                                else
			                                                        callback();//直接调用callback 不给参数表示通过验证
			                                        },
				                                trigger:"blur"
			                                }
		                                ],
			                        func_key:[
				                        {
                                                                validator:(rule,value, callback) => {
                                                                        // 如果是新增且没有选定绑定的组件 而且是叶子节点
                                                                        if(this.edit.mode && this.edit.isLeaf && value === "")
                                                                                callback(new Error("* 叶子节点，必须绑定组件！"));
                                                                        else
	                                                                        callback();
                                                                },
                                                                trigger:"blur"
				                        }
			                        ],
		                        }
	                        },
                        };
	        },
                computed:{
	                ...mapState(["list"]),//去壳
	                ...mapGetters(["listToTree"]),
                        treeData(){
                                return [{
                                        func_id:0,
	                                func_name:"Root",
	                                func_key:"",
	                                func_fid:-1,
	                                children:this.listToTree
//	                                children:this.$store.getters["func/listToTree"]
                                }];
                        },
	                selectData() {
                                let result = [ { label:"Root",value:0} ];//初始默认值
                                this.list.filter(item => item.func_key === "").forEach(item => {//找到所有的非叶子节点
                                        result.push({label:item.func_name,value:item.func_id});
                                });
                                return result;
	                },
                },
	        async created() {
                        //this.$store.dispatch("func/init");原始写法
		        this.init();//最终写法 映射过来以后的写法
//                        this.funcs = await this.$http({url: "/function/all" });
                        //console.log(this.funcs);//拿到数据给funcs
	        },
	        methods:{
		        ...mapActions(["init", "addFunc", "updateFunc", "removeFunc"]),
                        remove(node) {
                               //类似于上周自己封装的confirm节点
	                        this.$confirm(`您确定要删除 "${node.func_name}"节点吗？` , "警告",{type:"warning"})
		                        .then(async () => {
		                                //await this.$store.dispatch('func/removeFunc', node.func_id); 原始写法
		                                await this.removeFunc(node.func_id);//映射后的写法
		                                this.$message({
			                           message:`${node.func_name} 节点，删除成功！请刷新页面 查看最新菜单...`  ,
			                                type:"success"
		                                });
		                        })
		                        .catch(()=>{});

                        },
		        beginAdd(parentNode){
                                //参数：即将新增节点的父节点
			      this.$refs.form && this.$refs.form.resetFields(); //重置表单
				//打开对话看前所有准备工作的代码
			        this.edit.mode = true;//开始新增
			        this.edit.isLeaf = parentNode.func_id !==0;//除了root以外的非叶子节点
			        this.edit.model.func_id = 0;
			        this.edit.model.func_name = "";
			        this.edit.model.func_key = "";
			        this.edit.model.func_fid=parentNode.func_id;
			        //打开对话框开始新增
			        this.edit.isEdit = true;
		        },
                        beginUpdate(node){
                           this.$refs.form && this.$refs.form.resetFields(); //重置表单
                                //打开对话框前所有准备工作的代码
                                this.edit.mode = false;//开始修改
                                this.edit.isLeaf = node.func_key !== "";
                                this.edit.model.func_id =node.func_id;
                                this.edit.model.func_name = node.func_name;
                                this.edit.model.func_key = node.func_key;
                                this.edit.model.func_fid=node.func_fid;
                                //打开对话框开始修改
                                this.edit.isEdit = true;
                        },
		         save() {
                                //找到表单用代码的方式触发验证
			         //直接包裹await的函数要用async修饰
                                 this.$refs.form.validate(async valid => {
				        if(!valid) return;
                                        if(this.edit.mode){//新增
                                               // await this.$store.dispatch("func/addFunc",Object.assign({},this.edit.model));//调用函数，对页面进行操作
	                                        await this.addFunc(Object.assign({},this.edit.model));//映射写法
	                                        this.$message({
                                                        message:`${this.edit.model.func_name} 节点，新增成功！请刷新页面 查看最新菜单...`  ,
                                                        type:"success"
                                                });
                                        }else{
                                              //  await this.$store.dispatch("func/updateFunc",Object.assign({},this.edit.model));
                                               await this.updateFunc(Object.assign({},this.edit.model));//映射写法
                                                this.$message({
                                                        message:`${this.edit.model.func_name} 节点，修改成功！请刷新页面 查看最新菜单...`  ,
                                                        type:"success"
                                                });
                                        }
                                        this.edit.isEdit = false;//关闭编辑对话框
				});
		        }
	        },
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>
	.custom-tree
		width: 500px
		span.custom-tree-node
			flex: 1
			display:flex
			justify-content: space-between
			align-items: center
			span.root
				color:saddlebrown !important
				font-weight:bolder
			span.unleaf
				color:greenyellow
			span.leaf
				color #0094ff
</style>