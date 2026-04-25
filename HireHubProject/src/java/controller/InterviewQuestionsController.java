package controller;

import dal.InterviewQuestionDAO;
import model.InterviewQuestion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "InterviewQuestionsController", urlPatterns = {"/interview-questions"})
public class InterviewQuestionsController extends HttpServlet {

    private final InterviewQuestionDAO dao = new InterviewQuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword  = request.getParameter("keyword");
        String category = request.getParameter("category");
        String level    = request.getParameter("level");

        List<InterviewQuestion> questions = dao.search(keyword, category, level);

        request.setAttribute("questions",  questions);
        request.setAttribute("categories", dao.getCategories());
        request.setAttribute("keyword",    keyword  != null ? keyword  : "");
        request.setAttribute("category",   category != null ? category : "");
        request.setAttribute("level",      level    != null ? level    : "");
        request.setAttribute("totalCount", questions.size());

        request.getRequestDispatcher("/WEB-INF/views/interview_questions.jsp")
               .forward(request, response);
    }
}
