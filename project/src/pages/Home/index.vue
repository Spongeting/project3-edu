<template>
	<!--遵循子元素的父元素都是container的原则 container可以无限嵌套-->
	<el-container class="page-container">
		<el-header height="80px">
			<div class="header">
				<h1>青岛滨海学院教学管理系统 V 1.0</h1>
				<div class="header-user">
					<span>您好,    <span v-text="userName"></span>   欢迎登录滨海教学管理系统</span>
					<button @click="exit" class="exit">退出</button>
				</div>
			</div>
		</el-header>
		<el-container>
			<el-aside>
				<el-menu background-color="#606266" text-color="#fff" active-text-color="#ffd04b"
						:default-active="activeFuncKey" @select="menuSelectHandler">
					<template v-for="item in menuData">
						<el-menu-item v-if="item.func_key" :index="item.func_key"  :key="item.func_id" >
							<i class="el-icon-menu"></i>
							<span slot="title" v-text="item.func_name"></span>
						</el-menu-item>
						<el-submenu v-else :index="item.func_id.toString()"  :key="item.func_id" >
							<template slot="title">
								<i class="el-icon-setting"></i>
								<span  v-text="item.func_name"></span>
							</template>
							<!--判断一下非叶子节点是否有子节点-->
							<!--es6规定 最好不要把v-for 和v-if放到同一个标签中 -->
							<template v-if="item.children">
								<el-menu-item v-for="item2 in item.children" :key="item2.func_id"  :index="item2.func_key">
									<i class="el-icon-menu"></i>
									<span slot="title" v-text="item2.func_name"></span>
								</el-menu-item>
							</template>
						</el-submenu>
					</template>
					<!--<el-submenu>
						<template slot="title">
							<i class="el-icon-setting"></i>
							<span>系统管理</span>
						</template>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">系统用户管理</span>
						</el-menu-item>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">系统角色管理</span>
						</el-menu-item>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">系统功能管理</span>
						</el-menu-item>
					</el-submenu>
					<el-submenu>
						<template slot="title">
							<i class="el-icon-setting"></i>
							<span>人事管理</span>
						</template>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">人员管理</span>
						</el-menu-item>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">考勤管理（待开发...）</span>
						</el-menu-item>
					</el-submenu>
					<el-submenu>
						<template slot="title">
							<i class="el-icon-setting"></i>
							<span>教学管理</span>
						</template>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">班级管理</span>
						</el-menu-item>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">教室管理</span>
						</el-menu-item>
						<el-menu-item>
							<i class="el-icon-menu"></i>
							<span slot="title">学生管理</span>
						</el-menu-item>
					</el-submenu>

					<el-menu-item>
						<i class="el-icon-menu"></i>
						<span slot="title">密码修改</span>
					</el-menu-item>-->
				</el-menu>
			</el-aside>
			<el-container>
				<el-main>
					<el-tabs type="card" closable v-model="activeFuncKey"  @tab-remove="tabRemoveHandler">
						<el-tab-pane v-for="func_key in activeFuncKeys" :key="func_key "
						        :name="func_key"
							:label="menu.find(item => item.func_key === func_key).func_name">
							<component :is="views[func_key]"></component>
						</el-tab-pane>
					</el-tabs>
				</el-main>
				<el-footer>
					<!--转义字符 所有的转义字符都是& 加上；只是中间的内容不一样 lt:小于 gt：大于 -->
					版权所有&copy；2009H5刘金梅 网址：www.kengni.com
				</el-footer>
			</el-container>
		</el-container>
	</el-container>
</template>

<script type="text/ecmascript-6">
	import views from '../../views';//导入所有组件的功能地图
        import {createNamespacedHelpers} from 'vuex';//home组件中导入字典仓库  可以直接用不用再在各个组件页面中导入了
        let{mapActions:mapActionsFromDirctionary} = createNamespacedHelpers('dictionary');

	export  default {
	        name:"Home",
		data() {
	                return {
	                        userName:"",
	                        views,//模板中数据只能使用data中的数据 将导入的views的数据放在views中
				activeFuncKey:"",//实时记录当前激活的index
		                activeFuncKeys:[],//保存所有激活过的func_keys
                                //菜单中的每一个对象对应一个节点
                                //服务器回来的线性结构的数据
	                        menu:[]
	                }
		},
		async created(){
                        await this.dirInit();//初始化字典仓库中的数据
	                this.menu = await this.$http({
		                url:"/user//getmenu",
		                method:"post"
	                });
	             //   console.log(this.menu);
	                this.userName = sessionStorage.getItem("user_name");

		},
		methods:{
                        ...mapActionsFromDirctionary({"dirInit":"init"}),//初始化字典仓库中数据
	                menuSelectHandler(index,indexPath) {//回调函数 会自动收到两个参数 index:选中菜单项的func_key
	                        this.activeFuncKey = index;
	                        if(this.activeFuncKeys.indexOf(index) === -1){
                                      //1将激活过的func_key放到数组中 动态的渲染出来,
		                        // 渲染时会有两个问题
		                        // 1.1重复激活时  会重复渲染 方法：判断数组中是否已经存在这个元素 使用.indexOf或者find都可以
		                        //.indexOf判断数组中简单类型的数据  find:判断数组中复杂类型的数据
		                        //1.2 显示选项卡的标题  方法：label中可以写表达式
	                                this.activeFuncKeys.push(index);
	                        }
	                },
                        tabRemoveHandler(name){
	                        //tab-remove:是一个事件 会收到一个参数 表示要删除选项卡的name
	                        this.activeFuncKeys.splice(this.activeFuncKeys.indexOf(name),1);//在数组中移除对应的元素
	                        if(this.activeFuncKeys.indexOf( this.activeFuncKey) === -1){//刚删除的是激活的 判断一下当前激活的是不是不存在了
	                                this.activeFuncKey = this.activeFuncKeys[0] || ""; //将当前激活的index赋值为数组中的第一个元素 如果数组中元素都没了  就赋值为空
	                        }
			},
			exit() {
                                sessionStorage.removeItem("token");
                                sessionStorage.removeItem("user_name");
                                this.$router.replace("/login");
			}
		},
		computed:{
	                //利用计算属性将线性数据转换为树形数据 方便渲染
	                menuData() {
	                        let result = [];//存放转换为树形结构的数据
	                       this.menu.filter(item => item.func_fid === 0).forEach(item => {//先找到所有一级分类 迭代
	                             //深复制 在使用Object.assign的时候要求所有的数据都是值类型 简单类型的数据才可以
	                                 let node = Object.assign({}, item);
                                       //一级菜单迭代的过程中 找到所有对应的所有二级菜单
		                         let children = this.menu.filter(item2 => item2.func_fid === item.func_id);
		                         if(children.length > 0){//有二级菜单的话 给一级菜单动态开辟一个属性 将二级菜单保存在这个属性中
		                                 node.children = [];
		                                 children.forEach(item2 => node.children.push(Object.assign({}, item2)));
		                         }
		                         result.push(node);
	                       });
		                return result;
	                }
		},
	};
</script>

<style  lang="stylus" type="text/stylus" scoped>
	.page-container
		height: 100%
		.el-header
			color: #fff
			background-color: #303133
			display: flex
			align-items: center
			.header
				width 100%
				display flex
				justify-content space-between
				align-items center
				.header-user
					font-size 15px
					.exit
						margin 0px 10px
						padding 5px 10px
						background-color #999
						color #fff
						border-radius 4px
				h1
					font-size: 38px
		.el-aside
			background-color: #606266
			.el-menu
				border-right:none
		.el-footer
			display: flex
			align-items: center
			color:#fff
			background-color: #909399
		.el-main
			position: relative

	/*.page-container{  height:100%; }
	.el-header{
		color: #fff;
		background-color: #303133;
		display: flex;
		align-items: center;
	}
	.h1{ font-size: 38px }
	.el-aside{
		background-color: #606266;
		color: #fff;
	}
	.el-footer{
		background-color: #909399;
	}*/
</style>