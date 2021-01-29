//创建vuex对象 并导出
import Vue from 'vue';
import Vuex from 'vuex';
import http from "../utils/http.js";
import func from './func.js' ;
import role from './role.js';//导入
import classroom from './classroom.js';
import dictionary from './dictionary.js';

Vue.use(Vuex);

let store = new Vuex.Store({
        modules:{ func,role,classroom,dictionary},//拆分子仓库  使用
        state:{http},//存放组件的共用数据的
        getters:{},//仓库的计算属性
        mutations:{ },//修改数据
        actions:{}
});
export  default  store;