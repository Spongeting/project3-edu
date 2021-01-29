//导入http
import http from '../utils/http.js';
export default {
        namespaced:true,
        state:{//仓库自己发ajax 自己把请求的数据存储在仓库中
                list:[],
                isInit:false,//是否初始化
        },
        getters:{//仓库的计算属性
                listToTree(state){
                        let result = [];
                       state.list.filter(item => item.func_fid === 0).forEach(item => {
                                let node = Object.assign({},item);
                                let children = state.list.filter(item2 =>item2.func_fid === item.func_id );
                                if(children.length > 0){
                                        node.children = [];
                                        children.forEach(item2 => node.children.push(Object.assign({},item2)));
                                }
                                result.push(node);
                        });
                        return result;
                }
        },
        mutations:{
                _init(state,list){
                        state.list = list;
                        state.isInit = true;
                },
                _removeFunc(state,func_id){
                        let i =  state.list.findIndex(item => item.func_id === func_id);
                        state.list.splice(i,1);
                },
                _addFunc(state,func) {//发送ajax请求回来之后对数据的操作
                        state.list.push(func);
                },
                _updateFunc(state,func) {
                        let i = state.list.findIndex(item => item.func_id === func.func_id);
                        state.list.splice(i,1,func);
                }
        },
        actions:{
                async init(context) {
                        if(context.state.isInit) return;
                        let list = await http({url:"/function/all"});
                        context.commit('_init',list);
                },
                async removeFunc(context,func_id){
                        await http({
                                url:"/function/remove/"+func_id,
                                method:"post"
                        });
                        context.commit('_removeFunc',func_id);
                },
                async addFunc(context,func){//发送异步的ajax ，请求数据
                        func.func_id =  await http({
                                method:"post",
                                url:"/function/add",
                                data:func
                        });
                        context.commit("_addFunc",func);
                },
                async updateFunc(context,func){
                        await http({
                                method:"post",
                                url:"/function/update",
                                data:func
                        });
                        context.commit("_updateFunc",func);
                }
        }
};
