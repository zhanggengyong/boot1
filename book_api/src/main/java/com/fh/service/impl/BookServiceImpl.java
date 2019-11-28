package com.fh.service.impl;

import com.fh.entity.Book;
import com.fh.entity.Type;
import com.fh.mapper.BookMapper;
import com.fh.param.BookSearchParam;
import com.fh.service.BookService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class BookServiceImpl implements BookService {

    @Resource
    private BookMapper bookMapper;

    @Override
    public long queryCount(BookSearchParam bookSearchParam) {
        return bookMapper.queryCount(bookSearchParam);
    }

    @Override
    public List queryMapList(BookSearchParam bookSearchParam) {
        return bookMapper.queryMapList(bookSearchParam);
    }

    @Override
    public List<Type> queryTypeList() {
        return bookMapper.queryTypeList();
    }

    @Override
    public void addBook(Book book) {
        bookMapper.addBook(book);
    }

    @Override
    public void deleteBook(Integer id) {
        bookMapper.deleteBook(id);
    }

    @Override
    public Book toUpdate(Integer id) {
        return bookMapper.toUpdate(id);
    }

    @Override
    public void updateBook(Book book) {
        bookMapper.updateBook(book);
    }
}
