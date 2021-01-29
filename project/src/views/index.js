//统一导入导出
let flies=  require.context("./",true,/index.vue$/);//拿到了所有组件文件
let views = {} ;
flies.keys().forEach(filePath =>{//利用keys()函数 通过
        let key = filePath.match(/.*\/(.*)\/index.vue$/)[1];//拿到路径中两个斜杠之间的值作为views对象的键
        views[key] = flies(filePath).default;//将抠出来的内容作为键 调用files中的路径 有一个默认default 拿到组件文件的内容 作为键值
});
export  default  views;