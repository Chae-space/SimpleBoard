package com.chae.SimpleBoard.Board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BoardService {
	@Autowired
	private BoardMapper mapper;

	public void addBoard(Board b) {
		mapper.insert(b);
	}

	public Review getBoardByNum(int num) {
		return mapper.selectByNum(num);
	}
	
	public List getBoardByNickname(String writer) {
		return mapper.selectByNickname(writer);
	}

	public List selectAll() {
		return mapper.selectAll();
	}

	public void editBoard(Board b) {
		mapper.update(b);
	}

	public void delBoard(int num) {
		mapper.delete(num);
	}

	public int getNum() {
		return mapper.getNum();
	}
}
