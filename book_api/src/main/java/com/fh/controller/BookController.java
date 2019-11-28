package com.fh.controller;

import com.fh.entity.Book;
import com.fh.entity.Type;
import com.fh.param.BookSearchParam;
import com.fh.service.BookService;
import com.fh.utils.ServerResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("book")
@CrossOrigin
public class BookController {

    @Resource
    private BookService bookService;

    /*查询商品*/
    @RequestMapping("queryBookList")
    @ResponseBody
    public ServerResponse queryBookList(BookSearchParam bookSearchParam){
        long totalCount = bookService.queryCount(bookSearchParam);
        List<Book> list  = bookService.queryMapList(bookSearchParam);
        Map map= new HashMap();
        map.put("draw",bookSearchParam.getDraw());
        map.put("recordsTotal",totalCount);
        map.put("recordsFiltered",totalCount);
        map.put("data",list);
        return ServerResponse.success(map);
    }

    /*查询类型*/
    @RequestMapping("queryTypeList")
    @ResponseBody
    public ServerResponse queryTypeList(){
        List<Type> typeList  = bookService.queryTypeList();
        return ServerResponse.success(typeList);
    }

    /*添加商品*/
    @RequestMapping("addBook")
    @ResponseBody
    public ServerResponse addBook(Book book){
        bookService.addBook(book);
        return ServerResponse.success();
    }

    /*删除*/
    @RequestMapping("deleteBook")
    @ResponseBody
    public ServerResponse deleteBook(Integer id){
        bookService.deleteBook(id);
        return ServerResponse.success();
    }

    /*回显*/
    @RequestMapping("toUpdate")
    @ResponseBody
    public ServerResponse toUpdate(Integer id){
        Book book = bookService.toUpdate(id);
        return ServerResponse.success(book);
    }

    /*修改*/
    @RequestMapping("updateBook")
    @ResponseBody
    public ServerResponse updateBook(Book book){
        bookService.updateBook(book);
        return ServerResponse.success();
    }

}
