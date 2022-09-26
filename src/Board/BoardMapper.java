package com.chae.SimpleBoard.Board;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardMapper {
	void insert(Board b);

	Board selectByNum(int num);
	
	List selectByNickname(String writer);

	List selectAll();

	void update(Board b);

	void delete(int num);

	int getNum();
}
