package aptech.finalproject.service.product;

import aptech.finalproject.dto.response.product.FinanceResponse;

import java.time.LocalDate;
import java.util.List;

public interface FinanceService {
    FinanceResponse getOrderStatsByDay(LocalDate date);
    FinanceResponse getOrderStatsByWeek(int year, int week);
    FinanceResponse getOrderStatsByMonth(int year, int month);
    FinanceResponse getSalesStatsByDay(LocalDate date);
    FinanceResponse getSalesStatsByMonth(int year, int month);
    FinanceResponse getSalesStatsByYear(int year);
    List<FinanceResponse.TopProduct> getTopSellingProducts(int limit);
    List<FinanceResponse.TopProduct> getTopValueProducts(int limit);
}
