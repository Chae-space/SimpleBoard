package com.chae.SimpleBoard.Board;

import java.sql.Date;

import org.springframework.web.multipart.MultipartFile;

public class Board {
	private int num;
	private String writer;
	private String title;
	private int location;
	private String content;
	private Date date;

	private MultipartFile file1;
	private MultipartFile file2;
	private MultipartFile file3;

	public Board() {
		super();
	}

	public Board(int num, String writer, String title, int location, String content, Date date,
			MultipartFile file1, MultipartFile file2, MultipartFile file3) {
		super();
		this.num = num;
		this.writer = writer;
		this.title = title;
		this.location = location;
		this.content = content;
		this.date = date;
		this.file1 = file1;
		this.file2 = file2;
		this.file3 = file3;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getLocation() {
		return location;
	}

	public void setLocation(int location) {
		this.location = location;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public MultipartFile getFile1() {
		return file1;
	}

	public void setFile1(MultipartFile file1) {
		this.file1 = file1;
	}

	public MultipartFile getFile2() {
		return file2;
	}

	public void setFile2(MultipartFile file2) {
		this.file2 = file2;
	}

	public MultipartFile getFile3() {
		return file3;
	}

	public void setFile3(MultipartFile file3) {
		this.file3 = file3;
	}

	@Override
	public String toString() {
		return "Board [num=" + num + ", writer=" + writer + ", title=" + title + ", location=" + location
				+ ", content=" + content + ", date=" + date + ", file1=" + file1 + ", file2=" + file2 + ", file3="
				+ file3 + "]";
	}

}
