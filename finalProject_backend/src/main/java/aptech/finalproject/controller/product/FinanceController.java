package aptech.finalproject.controller.product;

import aptech.finalproject.dto.response.product.FinanceResponse;
import aptech.finalproject.service.product.FinanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/finance")
@RequiredArgsConstructor
public class FinanceController {

    private final FinanceService financeService;

    @GetMapping("/orders/day")
    public FinanceResponse getOrderStatsByDay(@RequestParam LocalDate date) {
        return financeService.getOrderStatsByDay(date);
    }

    @GetMapping("/orders/week")
    public FinanceResponse getOrderStatsByWeek(@RequestParam int year, @RequestParam int week) {
        return financeService.getOrderStatsByWeek(year, week);
    }

    @GetMapping("/orders/month")
    public FinanceResponse getOrderStatsByMonth(@RequestParam int year, @RequestParam int month) {
        return financeService.getOrderStatsByMonth(year, month);
    }

    @GetMapping("/sales/day")
    public FinanceResponse getSalesStatsByDay(@RequestParam LocalDate date) {
        return financeService.getSalesStatsByDay(date);
    }

    @GetMapping("/sales/month")
    public FinanceResponse getSalesStatsByMonth(@RequestParam int year, @RequestParam int month) {
        return financeService.getSalesStatsByMonth(year, month);
    }

    @GetMapping("/sales/year")
    public FinanceResponse getSalesStatsByYear(@RequestParam int year) {
        return financeService.getSalesStatsByYear(year);
    }

    @GetMapping("/top-selling")
    public List<FinanceResponse.TopProduct> getTopSellingProducts(@RequestParam(defaultValue = "10") int limit) {
        return financeService.getTopSellingProducts(limit);
    }

    @GetMapping("/top-value")
    public List<FinanceResponse.TopProduct> getTopValueProducts(@RequestParam(defaultValue = "10") int limit) {
        return financeService.getTopValueProducts(limit);
    }
}
