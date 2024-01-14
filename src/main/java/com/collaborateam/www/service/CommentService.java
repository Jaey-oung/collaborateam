package com.collaborateam.www.service;

import com.collaborateam.www.domain.CommentDto;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface CommentService {
    int getCount(Integer bno) throws Exception;
    List<CommentDto> getList(Integer bno) throws Exception;
    void removeAllComments(Integer bno) throws Exception;
    @Transactional(rollbackFor = Exception.class)
    int write(CommentDto commentDto) throws Exception;
    CommentDto read(Integer cno) throws Exception;
    int modify(CommentDto commentDto) throws Exception;
    @Transactional(rollbackFor = Exception.class)
    int remove(Integer cno, Integer bno, String commenter) throws Exception;
}