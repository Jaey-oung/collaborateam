package com.collaborateam.www.controller;

import com.collaborateam.www.domain.CommentDto;
import com.collaborateam.www.domain.MemberDto;
import com.collaborateam.www.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpSession;
import java.util.List;

@RestController
public class MemberController {
    @Autowired
    MemberService memberService;

    @RequestMapping("/members")
    public ResponseEntity<List<MemberDto>> list(Integer tno) {
        List<MemberDto> list;
        try {
            list = memberService.getList(tno);
            return new ResponseEntity<>(list, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/members")
    public ResponseEntity<String> write(@RequestBody MemberDto memberDto) {
        try {
            int rowCnt = memberService.create(memberDto);

            if(rowCnt != 1)
                throw new Exception("Member add failed");

            return new ResponseEntity<>("Successfully added the member", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to add the member", HttpStatus.BAD_REQUEST);
        }
    }
}