package com.chae.SimpleBoard.Board;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BoardController {
	@Autowired
	private BoardService service;
	@Autowired
	private HttpSession session;

	@GetMapping(value = "/Board/boardForm")
	public void boardForm() {

	}

	@RequestMapping(value = "/Board/boardList")
	public ModelAndView allList() {
		ModelAndView mav = new ModelAndView("Board/boardList");
		ArrayList<Board> list = (ArrayList<Board>) service.selectAll();
		mav.addObject("list", list);

		return mav;
	}

	private static final String PATH = "C:\\simpleBoard\\img\\Board\\";

	public void saveImg(MultipartFile file,int num, int fileNum) {
		String fileName = file.getOriginalFilename();
		
		// 확장자 추출
		int idx = fileName.lastIndexOf(".");
		String ext = fileName.substring(idx);
		
		if (fileName != null && !fileName.equals("")) {
			File dir = new File(PATH + num);
			if (!dir.exists()) { // 같은 이름이 존재하지 않을 경우
				dir.mkdirs(); // 폴더생성
			}

			File f = new File(PATH + num + "\\" + fileNum+ ext);

			try {
				file.transferTo(f);
			} catch (IllegalStateException e) {
				System.out.println(e);
			} catch (IOException e) {
				System.out.println(e);
			}
		}
	}

	@RequestMapping(value = "/Board/board")
	public String board(Board b) {
		int num = service.getNum();
		b.setNum(num);
		
		
		MultipartFile[] files = { b.getFile1(), b.getFile2(), b.getFile3() };
		
		for (int i = 0; i < files.length; i++) {
			if (!files[i].isEmpty()) {
				saveImg(files[i], num, i + 1);
			}
		}
		
		service.addBoard(b);

		return "redirect:/Board/boardList";
	}

	@RequestMapping(value = "/Board/boardDetail")
	public ModelAndView boardDetail(@RequestParam(value = "num") int num) {
		ModelAndView mav = new ModelAndView("Board/boardDetail");
		Board b = service.getBoardByNum(num);
		String path = PATH + b.getNum() + "\\";
		File imgDir = new File(path);

		if (imgDir.exists()) {
			String[] files = imgDir.list();
			for (int j = 0; j < files.length; j++) {
				mav.addObject("file" + j, files[j]);
			}
		}
		mav.addObject("b", b);
		return mav;
	}

	@RequestMapping(value = "/img")
	public ResponseEntity<byte[]> getImg(String fname, int num) {
		String path = PATH + num + "\\" + fname;
		File f = new File(path);
		HttpHeaders header = new HttpHeaders();
		ResponseEntity<byte[]> result = null;
		try {
			header.add("Content-Type", Files.probeContentType(f.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(f), header, HttpStatus.OK);
		} catch (IOException e) {
			System.out.println(e);
		}

		return result;
	}
	
	@RequestMapping(value="/Board/myBoardList")
	public ModelAndView myBoardList() {
		ModelAndView mav = new ModelAndView("Board/myBoardList");
		String writer = (String) session.getAttribute("nickname");
		ArrayList<Board> myBoard_list = (ArrayList<Board>) service.getBoardByNickname(writer);
		mav.addObject("myBoard_list", myBoard_list);
		
		return mav;
	}
	
	@RequestMapping(value="/Board/editBoardForm")
	public ModelAndView editboardForm(@RequestParam(value="num") int num) {
		ModelAndView mav = new ModelAndView("Board/editBoardForm");
		Board b = service.getBoardByNum(num);
		String path = PATH + b.getNum() + "\\";
		File imgDir = new File(path);

		if (imgDir.exists()) {
			String[] files = imgDir.list();
			for (int j = 0; j < files.length; j++) {
				mav.addObject("file" + j, files[j]);
			}
		}
		mav.addObject("b", b);
		return mav;
	}
	
	@RequestMapping(value="/Board/edit")
	public String edit(Board b) {
		service.editBoard(b);
		
		return "redirect:/Board/boardDetail?num=" + b.getNum();
	}
	
	@RequestMapping(value="/Board/delete")
	public String delete(@RequestParam(value="num") int num) {
		service.delBoard(num);
		String path = PATH + num + "\\";
		File imgDir = new File(path);
		
		if (imgDir.exists()) {
			String[] files = imgDir.list();
			for (int j = 0; j < files.length; j++) {
				File f = new File(path + files[j]);
				f.delete();
			}
		}
		imgDir.delete();
		
		return "redirect:/Board/boardList";
	}

}
