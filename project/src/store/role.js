import http from '../utils/http.js';
//导出
export default {
        namespaced:true,
        state:{//初始数据
                list:[],//存放发送ajax后请求的数据
                isInit:false,//是否初始化
        },
        mutations:{
                _init(state,list){//初始化
                        state.list = list;
                        state.isInit = true;
                },
                _removeRole(state,role_id){
                        let i = state.list.findIndex(item => item.role_id === role_id);
                        state.list.splice(i,1);
                },
                _addRole(state,role){
                        state.list.push(role);
                },
                _updateRole(state,role){
                        let i = state.list.findIndex(item => item.role_id === role.role_id);
                        state.list.splice(i,1,role);
                }

        },//同步数据操作
        actions:{//异步数据操作
                async init(context) {//初始化数据
                        if(context.state.isInit) return;
                        let list = await http({url:"/role/all"});
                        context.commit("_init",list);
                },
                async removeRole(context,role_id) {//删除数据
                        await http({
                                url:"/role/remove/"+role_id,
                                method:"post"
                        });
                        context.commit("_removeRole",role_id);
                },
                async addRole(context,role) {//新增
                      role.role_id =  await http({
                                method:"post",
                                url:"/role/add",
                                data:role
                        });
                        context.commit("_addRole",role);
                },
                async updateRole(context,role) {//修改
                        await http({
                                url:"/role/update",
                                method:"post",
                                data:role
                        });
                        context.commit("_updateRole",role);
                }
        }
};