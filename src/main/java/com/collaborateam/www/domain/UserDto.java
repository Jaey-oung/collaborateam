package com.collaborateam.www.domain;

import java.util.Date;
import java.util.Objects;

public class UserDto {
    private String id;
    private String pwd;
    private String email;
    private String name;
    private Date birth;
    private Date regDate;
    private Date upDate;

    public UserDto() {}
    public UserDto(String id, String pwd, String email, String name, Date birth) {
        this.id = id;
        this.pwd = pwd;
        this.email = email;
        this.name = name;
        this.birth = birth;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserDto userDto = (UserDto) o;
        return Objects.equals(id, userDto.id) && Objects.equals(pwd, userDto.pwd) && Objects.equals(email, userDto.email) && Objects.equals(name, userDto.name) && Objects.equals(birth, userDto.birth) && Objects.equals(regDate, userDto.regDate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, pwd, email, name, birth, regDate);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getBirth() {
        return birth;
    }

    public void setBirth(Date birth) {
        this.birth = birth;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public Date getUpDate() {
        return upDate;
    }

    public void setUpDate(Date upDate) {
        this.upDate = upDate;
    }

    @Override
    public String toString() {
        return "UserDto{" +
                "id='" + id + '\'' +
                ", pwd='" + pwd + '\'' +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", birth=" + birth +
                ", regDate=" + regDate +
                ", upDate=" + upDate +
                '}';
    }
}
