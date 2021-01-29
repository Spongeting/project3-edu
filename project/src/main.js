 import  Vue from 'vue';

 //导入复位样式
 import './assets/css/reset.css';
 import http from './utils/http.js';

 import ElementUI from 'element-ui';
 import 'element-ui/lib/theme-chalk/index.css';
 import router from './router';
 import store from './store';
 import app from './App.vue';

 Vue.use(ElementUI);
 Vue.prototype.$http = http;
//创建根实例 并渲染根组件
new Vue({
        el:"#app",
        /*render: h => h*/
        components:{app},
        template:"<app />",
        router,
        store
});