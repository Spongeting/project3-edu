import http from '../utils/http.js';
export default {
        namespaced:true,
        state:{
                list:[],//存储初始化数据
                isInit:false,//是否初始化
        },
        mutations:{
                 _init(state,list){//初始化
                   state.list = list;
                   state.isInit = true;
                 },
                _removeClsr(state,clsr_id) {//删除
                   let i = state.list.findIndex(item => item.clsr_id === clsr_id);
                   state.list.splice(i,1);
                 },
               _addClsr(state,clsr) {//新增
                       state.list.push(clsr);
               },
                _updateClsr(state,clsr) {//修改
                        let i = state.list.findIndex(item => item.clsr_id === clsr.clsr_id);
                        state.list.splice(i,1,clsr);
                 }
        }

        ,
        actions:{
                async init(context) {
                        if(context.state.isInit) return;
                        let list = await http({ url:"/classroom/all" });
                        context.commit("_init",list);
                },
                async removeClsr(context,clsr_id) {
                        await http({ url:"/classroom/remove/"+clsr_id});
                        context.commit("_removeClsr",clsr_id);
                },
                async addClsr(context,clsr) {
                         clsr.clsr_id = await http({
                                url:"/classroom/add",
                                method:"post",
                                data:clsr
                        });
                        context.commit("_addClsr",clsr);
                },
                async updateClsr(context,clsr) {
                        await http({
                                url:"/classroom/update",
                                method:"post",
                                data:clsr
                        });
                        context.commit("_updateClsr",clsr);
                }
        }
};