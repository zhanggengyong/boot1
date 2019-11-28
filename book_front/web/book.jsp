<%--
  Created by IntelliJ IDEA.
  User: gy
  Date: 2019/10/13
  Time: 14:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Title</title>
<jsp:include page="/common/script.jsp"></jsp:include>

</head>
<script type="text/html" id="showUpdateDiv">
    <div>
        <form class="form-horizontal" >
            <div class="form-group">
                <label  class="col-sm-2 control-label">图书名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="update_productName" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">图书价格</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="update_price" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">图书类型</label>
                <div class="col-sm-4">
                    <select class="form-control"  id="update_brand">
                        <option value="-1">==请选择==</option>

                    </select>
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">出版日期</label>
                <div class="col-sm-4">
                    <input type="text" name="createDate" id="update_createDate" class="form-control "  >
                </div>
            </div>
        </form>


    </div>


</script>
<script type="text/html" id="showAddDiv">
    <div  >
        <form class="form-horizontal" id="formApp" >
            <div class="form-group">
                <label  class="col-sm-2 control-label">图书名称</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_productName" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">图书价格</label>
                <div class="col-sm-4">
                    <input type="text" name="price" class="form-control" id="add_price" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">图书类型</label>
                <div class="col-sm-4">
                    <select class="form-control"  id="add_brand">
                        <option value="-1">==请选择==</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">生产日期</label>
                <div class="col-sm-4">
                    <input type="text" name="createDate" id="add_createDate" class="form-control "  >
                </div>
            </div>
        </form>
    </div>
</script>

<script>
    $(function(){
        initDateTable();
        initBrandList();
        initDate();

    })
    function deleteProduct(id){
        window.event.stopPropagation()// 阻止冒泡
        bootbox.dialog({
            message: "确认删除",
            title: "提示信息",
            buttons: {
                Cancel: {
                    label: "取消",
                    className: "btn-default",
                    callback: function () {

                    }
                }
                , OK: {
                    label: "确认",
                    className: "btn-danger",
                    callback: function () {
                        $.post(
                            "http://localhost:8081/book/deleteBook",
                            {"id":id},
                            function(data){
                                if(data.status==200){
                                    queryList();
                                }else{
                                    bootbox.alert("系统异常，请联系管理员！", function () {

                                    })
                                }
                            }
                        )
                    }
                }
            }
        });
    }

    function  initUpdateBrandList() {
        //开启同步加载 防止修改页面  品牌回显是好时坏
        $.ajaxSettings.async = false;
        $.post(
            "http://localhost:8081/book/queryTypeList",
            function(result){
                if(result.status==200){
                    var data=result.data;
                    for (var i = 0; i < data.length; i++) {
                        $("#update_brand").append(
                            '<option value="'+data[i].id+'">'+data[i].typeName+'</option>'
                        )

                    }

                }
            }
        )
        $.ajaxSettings.async = true;
    }

    function initUpdateDate(){
        $('#update_createDate').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN'

        });
    }
    function toUpdate(id){
       window.event.stopPropagation()// 阻止冒泡
        bootbox.dialog({
            message: $("#showUpdateDiv").html(),
            title: "修改",
            buttons: {
                Cancel: {
                    label: "取消",
                    className: "btn-default",
                    callback: function () {

                    }
                }
                , OK: {
                    label: "确认",
                    className: "btn-danger",
                    callback: function () {
                        var param={};
                        param.name=$("#update_productName").val();
                        param.price=$("#update_price").val();
                        param.typeId=$("#update_brand").val();
                        param.publicationTime=$("#update_createDate").val();
                        param.id=id;

                        $.post(
                            "http://localhost:8081/book/updateBook",
                            param,
                            function (data) {
                                if(data.status==200){
                                    queryList();
                                }else{
                                    bootbox.alert("操作失败！,请联系管理员",function(){

                                    })
                                }

                            }
                        )
                    }
                }
            }
        });
        //获取所有的品牌
        initUpdateBrandList();
        $.post(
            "http://localhost:8081/book/toUpdate",
            {"id":id},
            function (result) {
                if(result.status==200){
                    var data=result.data;
                $("#update_productName").val(data.name);
                $("#update_price").val(data.price);
                $("#update_brand").val(data.typeName);
                $("#update_createDate").val(new Date(data.publicationTime).toLocaleDateString());
                initUpdateDate();
                }
            }
        )


    }

    function initDateTable(){
        myTable =    $('#example').DataTable({
            "serverSide": true,
            // 是否允许检索
            "searching": false,
            "lengthMenu": [5, 10, 20,50],
            "ajax": {
                url: 'http://localhost:8081/book/queryBookList',
                type: 'POST',
                "data": function(d){
                    //添加额外的参数传给服务器
                    d.productName = $("#productName").val();
                    d.brandId = $("#brand").val();
                    d.minPrice = $("#minPrice").val();
                    d.maxPrice = $("#maxPrice").val();
                    d.minDate = $("#minDate").val();
                    d.maxDate = $("#maxDate").val();
                },
                //用于处理服务器端返回的数据。 dataSrc是DataTable特有的
                dataSrc: function (result) {
                    if (result.status==200) {
                        result.draw = result.data.draw;
                        result.recordsTotal = result.data.recordsTotal;
                        result.recordsFiltered = result.data.recordsFiltered;
                        return result.data.data;
                    }else{
                        return "";
                    }

                },
                "error": function (xhr, error, thrown){
                    console.error(error);
                }
            },
            "columns": [
                {"data":"id",render:function (data,type,row,meta) {
                        return '<input type="checkbox" value="'+data+'" name="ids">';
                    }},
                { "data": "name" },
                { "data": "price" },
                { "data": "typeId"},
                { "data": "publicationTime",
                    render:function (data,type,row,meta) {
                        return new Date(data).toLocaleDateString();
                    }},

                {"data":"id",render:function(data,type,row,meta){
                        //先把上下架的值取出
                        //定义按钮的value值
                        var v_stand =row.status;
                        var buttonText = "";
                        v_class = "";
                        var v_status ;
                        if(v_stand==1){
                            buttonText = "下架";
                            v_class = "btn btn-warning";
                            v_icon = "glyphicon glyphicon-arrow-down";
                        }else{
                            buttonText = "上架";
                            v_class = "btn btn-warning";
                            v_icon = "glyphicon glyphicon-arrow-up";
                            v_status = 1;
                        }
                        v_status = 0;
                        return ' <div class="btn-group" role="group" aria-label="...">'+
                            '<button type="button" class="btn btn-info" onclick="toUpdate('+data+')"><i class="glyphicon glyphicon-wrench"></i>修改</button>'+
                            '<button type="button" class="btn btn-danger" onclick="deleteProduct('+data+')"><i class="glyphicon glyphicon-remove"></i>删除</button>';

                        '</div>';
                    }}
            ],
            "initComplete":function (setting,json) {

            },
            "drawCallback": function( settings ) {
                console.log(idList);
                if(idList.length>0){
                    $("[name='ids']").each(function () {
                        if(idList.indexOf(this.value)!=-1){
                            this.checked=true;
                            $(this).parent().parent().css("background-color","#66afe9");
                        }
                    })
                }

            },
            "language": {
                "sProcessing":   "处理中...",
                "sLengthMenu":   "_MENU_ 记录/页",
                "sZeroRecords":  "没有匹配的记录",
                "sInfo":         "显示第 _START_ 至 _END_ 项记录，共 _TOTAL_ 项",
                "sInfoEmpty":    "显示第 0 至 0 项记录，共 0 项",
                "sInfoFiltered": "(由 _MAX_ 项记录过滤)",
                "sInfoPostFix":  "",
                "sSearch":       "过滤:",
                "sUrl":          "",
                "oPaginate": {
                    "sFirst":    "首页",
                    "sPrevious": "上页",
                    "sNext":     "下页",
                    "sLast":     "末页"
                }
            }
        });
    }
   /* function initDateTable(){
        myTable =    $('#example').DataTable({
            "serverSide": true,
            // 是否允许检索
            "searching": false,
            "lengthMenu": [5, 10, 20,50],
            "ajax": {
                url: 'http://localhost:8081/book/queryBookList',
                type: 'POST',
                "data": function(d){
                    //添加额外的参数传给服务器
                    // d.productName = $("#productName").val();
                    // d.brandId = $("#brand").val();
                    // d.minPrice = $("#minPrice").val();
                    // d.maxPrice = $("#maxPrice").val();
                    // d.minDate = $("#minDate").val();
                    // d.maxDate = $("#maxDate").val();
                },
                //用于处理服务器端返回的数据。 dataSrc是DataTable特有的
                dataSrc: function (result) {
                    if (result.status==200) {
                        result.draw = result.data.draw;
                        result.recordsTotal = result.data.recordsTotal;
                        result.recordsFiltered = result.data.recordsFiltered;
                        return result.data.data;
                    }else{
                        return "";
                    }

                },
                "error": function (xhr, error, thrown){
                    console.error(error);
                }
            },
            "columns": [
                {"data":"id",render:function (data,type,row,meta) {
                    return '<input type="checkbox" value="'+data+'" name="ids">';
                }},
                { "data": "name" },
                { "data": "price" },
                { "data": "typeName" },
                { "data": "publicationTime",
                    render:function (data,type,row,meta) {
                        return new Date(data).toLocaleDateString();
                    }},
                {"data":"id",render:function(data,type,row,meta){
                 return ' <div class="btn-group" role="group" aria-label="...">'+
                           '<button type="button" class="btn btn-info" onclick="toUpdate('+data+')"><i class="glyphicon glyphicon-wrench"></i>修改</button>'+
                           '<button type="button" class="btn btn-danger" onclick="deleteProduct('+data+')"><i class="glyphicon glyphicon-remove"></i>删除</button>'+
                        '</div>';
                }}
            ],
            "initComplete":function (setting,json) {

            },
            "drawCallback": function( settings ) {
             console.log(idList);
             if(idList.length>0){
                 $("[name='ids']").each(function () {
                     if(idList.indexOf(this.value)!=-1){
                         this.checked=true;
                         $(this).parent().parent().css("background-color","#66afe9");
                     }
                 })
             }

            },
            "language": {
                "sProcessing":   "处理中...",
                "sLengthMenu":   "_MENU_ 记录/页",
                "sZeroRecords":  "没有匹配的记录",
                "sInfo":         "显示第 _START_ 至 _END_ 项记录，共 _TOTAL_ 项",
                "sInfoEmpty":    "显示第 0 至 0 项记录，共 0 项",
                "sInfoFiltered": "(由 _MAX_ 项记录过滤)",
                "sInfoPostFix":  "",
                "sSearch":       "过滤:",
                "sUrl":          "",
                "oPaginate": {
                    "sFirst":    "首页",
                    "sPrevious": "上页",
                    "sNext":     "下页",
                    "sLast":     "末页"
                }
            }
        });
    }*/
    function exitId(id){
        if(idList.indexOf(id)==-1){
            return false;
        }else{
            return true;
        }
    }
    function  initBrandList() {
        $.post(
            "http://localhost:8081/book/queryTypeList",
            function(data){
                if(data.status==200){
                    var data=data.data;
                    for (var i = 0; i < data.length; i++) {
                       $("#brand").append(
                           '<option value="'+data[i].id+'">'+data[i].typeName+'</option>'
                       )

                    }

                }
            }
        )

    }
    function initDate(){
        $('#minDate').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN'

        });
        $('#maxDate').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN',
            showClear:true
        });


    }
    function queryList(){
        $("#example").dataTable().fnDraw(false);//点击事件触发table重新请求服务器
    }
    function showAddProduct(){
        bootbox.dialog({
            message: $("#showAddDiv").html(),
            title: "添加",
            size:"large",
            buttons: {
                Cancel: {
                    label: "取消",
                    className: "btn-default",
                    callback: function () {

                    }
                }
                , OK: {
                    label: "确认",
                    className: "btn-danger",
                    callback: function () {
                        //获取当前表单验证状态
                        var flag =  $("#formApp").data("bootstrapValidator").isValid();
                       if(flag){
                           var param={};
                           param.name=$("#add_productName").val();
                           param.price=$("#add_price").val();
                           param.typeId=$("#add_brand").val();
                           param.publicationTime=$("#add_createDate").val();
                           $.post(
                               "http://localhost:8081/book/addBook",
                               param,
                               function (data) {
                                   if(data.status==200){
                                       queryList();
                                   }else{
                                       bootbox.alert("操作失败！,请联系管理员",function(){

                                       })
                                   }

                               }
                           )
                       }else{
                           bootbox.alert("请输入名称！")
                       }

                    }
                }
            }
        });
        //获取所有的品牌
        initAddBrandList();
        //初始化日期插件
        initAddDate();
        //加载表单验证
        initFormValidator()

    }
    function initFormValidator(){
        $('#formApp').bootstrapValidator({
            // 默认的提示消息
            message: 'This value is not valid',
            // 表单框里右侧的icon
            submitButtons: 'btn-danger',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                name: {
                    message: '商品名验证失败',
                    validators: {
                        notEmpty: {
                            message: '商品名不能为空'
                        }
                    }
                },
                price: {
                    validators: {
                        notEmpty: {
                            message: '价格不能为空'
                        }
                    }
                }
            }
        });
    }

    function initAddBrandList() {
        $.post(
            "http://localhost:8081/book/queryTypeList",
            function (result) {
                if(result.status==200){
                    var data=result.data;
                    for (var i = 0; i < data.length; i++) {
                        $("#add_brand").append(
                            "<option value='"+data[i].id+"'>"+data[i].typeName+"</option>"
                        );

                    }
                }
            }
        )
    }
    function initAddDate(){
        $('#add_createDate').datetimepicker({
            format:"YYYY-MM-DD",
            showClear: true
        });
    }
    var idList=[];
    //为DataTables表格中每一行绑定单击事件
    /*function initBindEvent(){
        $('#example').on('click', 'tr',function() {
            var data = myTable.row(this).data(); //获取单击那一行的数据

            console.log(data);
            //获取复选框
            var checkBox = $(this).find("[name='ids']")[0];
            if(checkBox.checked){
                checkBox.checked = false;
                $(this).css("background-color","");
                idList.splice(idList.indexOf(checkBox.value),1);
            }else{
                checkBox.checked = true;
                $(this).css("background-color","#66afe9");
                idList.push(checkBox.value);
            }
          //  alert(checkBox.value)
           // $(this).css("background-color","pink");
           // alert( data );
        } );

    }*/
    function xuan(){
        window.event.stopPropagation()// 阻止冒泡
        $("[name='ids']").each(function(){
            if(!this.checked){
                $(this).parent().parent().css("background-color","#66afe9");
                idList.push(this.value)

            }else{
                $(this).parent().parent().css("background-color","");
                idList.splice(idList.indexOf(this.value),1)
            }
            this.checked=!this.checked;

        })
    }






</script>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-3">

        </div>
        <div class="col-md-9">
            <%--<form class="form-horizontal" id="searchForm" >
                <div class="form-group">
                    <label for="productName" class="col-sm-2 control-label">商品名称</label>
                    <div class="col-sm-3">
                        <input type="email" class="form-control" id="productName" placeholder="商品名称" name="productName">
                    </div>
                    <label for="brand" class="col-sm-2 control-label">商品品牌</label>
                    <div class="col-sm-3">
                        <select class="form-control" id="brand" name="brandId">
                            <option value="-1">请选择</option>

                        </select>
                    </div>
                    <div class="col-md-2"></div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">价格</label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <input type="text" id="minPrice" name="minPrice" class="form-control" placeholder="0.00" aria-describedby="basic-addon1">
                            <span class="input-group-addon" id="basic-addon1"><i class="glyphicon glyphicon-resize-horizontal"></i></span>
                            <input type="text"  id="maxPrice" name="maxPrice" class="form-control" placeholder="0.00" aria-describedby="basic-addon1">
                        </div>
                    </div>
                    <label  class="col-sm-2 control-label">创建日期</label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <input type="text" id="minDate" name="minDate" class="form-control" placeholder="" aria-describedby="basic-addon1">
                            <span class="input-group-addon" id="basic-addon2"><i class="glyphicon glyphicon-calendar"></i></span>
                            <input type="text" id="maxDate" name="maxDate" class="form-control" placeholder="" aria-describedby="basic-addon1">
                        </div>
                    </div>
                    <div class="col-md-2"></div>
                </div>


                    <div style="text-align: center">
                        <button type="button" onclick="queryList()" class="btn btn-primary "><i class="glyphicon glyphicon-search"></i>Submit</button>&nbsp;&nbsp;&nbsp;
                        <button type="reset" class="btn btn-default"><i class="glyphicon glyphicon-repeat"></i>Reset</button>
                    </div>

            </form>--%>


            <div class="panel panel-primary" >
                <!-- Default panel contents -->

                    <div class="panel-heading" style="text-align: left">
                        <button type="button" class="btn btn-success" onclick="showAddProduct()"><i class="glyphicon glyphicon-plus"></i>增加商品</button>

                    </div>

               <div  class="panel-body">
                <!-- Table -->
                   <table id="example" class="table table-striped table-bordered" style="width:100%">
                       <thead>
                       <tr >
                           <th><input type="checkbox" onclick="xuan()">选择</th>
                           <th>图书名称</th>
                           <th>图书价格</th>
                           <th>商品类型</th>
                           <th>生产时间</th>
                           <th>操作</th>

                       </tr>
                       </thead>

                       <tfoot>
                       <tr>
                           <th><input type="checkbox" onclick="xuan()">选择</th>
                           <th>图书名称</th>
                           <th>图书价格</th>
                           <th>商品类型</th>
                           <th>生产时间</th>
                           <th>操作</th>
                       </tr>
                       </tfoot>
                   </table>
               </div>
            </div>
        </div>

    </div>


</div>
<%--修改--%>

</body>
</html>
