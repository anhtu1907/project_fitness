package aptech.finalproject.service;

public interface EmailService {
    void send(String to, String subject, String body);
    void sendHtml(String to, String subject, String body);
}
