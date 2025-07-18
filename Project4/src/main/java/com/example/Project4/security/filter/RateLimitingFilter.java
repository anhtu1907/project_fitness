package com.example.Project4.security.filter;


import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RateLimitingFilter implements Filter {

    @Value("${app.config.filter.limitTimeWindow}")
    private  long  LIMIT_TIME_WINDOW;
    @Value("${app.config.filter.maxRequest}")
    private  int  MAX_REQUEST;

    private final Map<String, RequestCounter> ipRequestMap = new ConcurrentHashMap<>();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        String ip = request.getRemoteAddr();
        long now = Instant.now().toEpochMilli();

        RequestCounter counter = ipRequestMap.computeIfAbsent(ip, k-> new RequestCounter(0, now));

        synchronized (counter) {
            if(now - counter.startTime > LIMIT_TIME_WINDOW) {
                counter.startTime = now;
                counter.count = 1;
            }else{
                counter.count++;
            }

            if(counter.count >= MAX_REQUEST) {
                HttpServletResponse res = (HttpServletResponse) response;
                res.setStatus(429);
                res.getWriter().write("Too many requests. Please try again later.");
                return;
            }
        }
        chain.doFilter(request, response);
    }

    static class RequestCounter {
        int count;
        long startTime;

        RequestCounter(int count, long startTime) {
            this.count = count;
            this.startTime = startTime;
        }
    }

    @Scheduled(fixedRate = 300000)
    public void cleanOldEntities() {
        long now = Instant.now().toEpochMilli();
        ipRequestMap.entrySet().removeIf(entry -> now - entry.getValue().startTime > LIMIT_TIME_WINDOW);
    }
}
