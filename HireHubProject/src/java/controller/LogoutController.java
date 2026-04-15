package controller;

import dal.RefreshTokenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller for user logout.
 * GET /logout - Invalidate session and redirect to login
 */
@WebServlet(name = "LogoutController", urlPatterns = {"/logout"})
public class LogoutController extends HttpServlet {

    private final RefreshTokenDAO refreshTokenDAO = new RefreshTokenDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            String refreshToken = (String) session.getAttribute("refreshToken");
            if (refreshToken != null && !refreshToken.trim().isEmpty()) {
                refreshTokenDAO.revokeTokenByValue(refreshToken);
            }
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/login?success=logged_out");
    }
}
