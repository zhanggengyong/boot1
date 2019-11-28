package com.fh.service;

import com.fh.entity.Book;
import com.fh.entity.Type;
import com.fh.param.BookSearchParam;

import java.util.List;

public interface BookService {
    long queryCount(BookSearchParam bookSearchParam);

    List queryMapList(BookSearchParam bookSearchParam);

    List<Type> queryTypeList();

    void addBook(Book book);

    void deleteBook(Integer id);

    Book toUpdate(Integer id);

    void updateBook(Book book);
}
