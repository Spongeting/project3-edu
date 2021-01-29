export default {
        namespaced:true,
        state:{
                staffCategorylist:[],
                qualificationlist:[],
                classMajorlist:[],
                isInit:false
        },
getters:{
               /* getGroupByKey(state) {
                        return function(groupKey){
                         //让计算属性返回一个函数 state.list变了 产生新的函数  因为是根据当前list产生的函数
                                   return state.list.filter(item => item.dic_group_key === groupKey);
                        };
                }*/
},
        mutations:{
                _init(state,list){
                        state.staffCategorylist = list.filter(item => item.dic_group_key === "staff_category");
                        state.qualificationlist = list.filter(item => item.dic_group_key === "qualification");
                        state.classMajorlist = list.filter(item => item.dic_group_key === "class_major");
                        state.isInit = true;
                }
        },
        actions:{
                async init({state,commit,rootState}) {
                        if(state.isInit) return;
                        let list = await rootState.http ({url:"/dictionary/all",});
                       // console.log(list);
                        commit("_init",list);
                }
        },
};