package aptech.finalproject.service.product;

import aptech.finalproject.dto.response.product.FinanceResponse;
import aptech.finalproject.entity.product.Order;
import aptech.finalproject.entity.product.OrderDetail;
import aptech.finalproject.repository.product.OrderDetailRepository;
import aptech.finalproject.repository.product.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.WeekFields;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class FinanceServiceImpl implements FinanceService {
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private OrderDetailRepository orderDetailRepository;

    @Override
    public FinanceResponse getOrderStatsByDay(LocalDate date) {
        List<Order> orders = orderRepository.findByOrderDateBetween(
                date.atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
                date.plusDays(1).atStartOfDay().toInstant(java.time.ZoneOffset.UTC)
        );

        // Tính tổng doanh thu
        BigDecimal totalSales = orders.stream()
                .map(order -> order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Lấy danh sách sản phẩm bán chạy
        List<FinanceResponse.TopProduct> topSellingProducts = getTopSellingProducts(10);

        // Lấy danh sách sản phẩm có giá trị cao nhất
        List<FinanceResponse.TopProduct> topValueProducts = getTopValueProducts(10);

        // Tạo response
        FinanceResponse response = new FinanceResponse();
        response.setOrderCount(orders.size());
        response.setTotalSales(totalSales);
        response.setTopSellingProducts(topSellingProducts);
        response.setTopValueProducts(topValueProducts);

        return response;
    }

    @Override
    public FinanceResponse getOrderStatsByWeek(int year, int week) {
        LocalDate start = LocalDate.ofYearDay(year, 1)
                .with(WeekFields.ISO.weekOfYear(), week)
                .with(WeekFields.ISO.dayOfWeek(), 1);
        LocalDate end = start.plusWeeks(1);

        List<Order> orders = orderRepository.findByOrderDateBetween(
                start.atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
                end.atStartOfDay().toInstant(java.time.ZoneOffset.UTC)
        );

        BigDecimal totalSales = orders.stream()
                .map(order -> order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<FinanceResponse.TopProduct> topSellingProducts = getTopSellingProducts(10);
        List<FinanceResponse.TopProduct> topValueProducts = getTopValueProducts(10);

        FinanceResponse response = new FinanceResponse();
        response.setOrderCount(orders.size());
        response.setTotalSales(totalSales);
        response.setTopSellingProducts(topSellingProducts);
        response.setTopValueProducts(topValueProducts);

        return response;
    }

    @Override
    public FinanceResponse getOrderStatsByMonth(int year, int month) {
        LocalDate start = LocalDate.of(year, month, 1);
        LocalDate end = start.plusMonths(1);

        List<Order> orders = orderRepository.findByOrderDateBetween(
                start.atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
                end.atStartOfDay().toInstant(java.time.ZoneOffset.UTC)
        );

        BigDecimal totalSales = orders.stream()
                .map(order -> order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<FinanceResponse.TopProduct> topSellingProducts = getTopSellingProducts(10);
        List<FinanceResponse.TopProduct> topValueProducts = getTopValueProducts(10);

        FinanceResponse response = new FinanceResponse();
        response.setOrderCount(orders.size());
        response.setTotalSales(totalSales);
        response.setTopSellingProducts(topSellingProducts);
        response.setTopValueProducts(topValueProducts);

        return response;
    }

    @Override
    public FinanceResponse getSalesStatsByDay(LocalDate date) {
        List<Order> orders = orderRepository.findByOrderDateBetween(
                date.atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
                date.plusDays(1).atStartOfDay().toInstant(java.time.ZoneOffset.UTC)
        );

        BigDecimal totalSales = orders.stream()
                .map(order -> order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<FinanceResponse.TopProduct> topSellingProducts = getTopSellingProducts(10);
        List<FinanceResponse.TopProduct> topValueProducts = getTopValueProducts(10);

        FinanceResponse response = new FinanceResponse();
        response.setTotalSales(totalSales);
        response.setTopSellingProducts(topSellingProducts);
        response.setTopValueProducts(topValueProducts);

        return response;
    }

    @Override
    public FinanceResponse getSalesStatsByMonth(int year, int month) {
        LocalDate start = LocalDate.of(year, month, 1);
        LocalDate end = start.plusMonths(1);

        List<Order> orders = orderRepository.findByOrderDateBetween(
                start.atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
                end.atStartOfDay().toInstant(java.time.ZoneOffset.UTC)
        );

        BigDecimal totalSales = orders.stream()
                .map(order -> order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<FinanceResponse.TopProduct> topSellingProducts = getTopSellingProducts(10);
        List<FinanceResponse.TopProduct> topValueProducts = getTopValueProducts(10);

        FinanceResponse response = new FinanceResponse();
        response.setTotalSales(totalSales);
        response.setTopSellingProducts(topSellingProducts);
        response.setTopValueProducts(topValueProducts);

        return response;
    }


    @Override
    public FinanceResponse getSalesStatsByYear(int year) {
        // Calculate start and end of the year
        LocalDate start = LocalDate.of(year, 1, 1);
        LocalDate end = start.plusYears(1);

        // Log the date range for debugging
        System.out.println("Yearly stats date range: " + start + " to " + end);

        // Fetch orders within the date range
        List<Order> orders = orderRepository.findByOrderDateBetween(
                start.atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
                end.atStartOfDay().toInstant(java.time.ZoneOffset.UTC)
        );

        // Calculate total sales
        BigDecimal totalSales = orders.stream()
                .map(order -> order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Fetch top products
        List<FinanceResponse.TopProduct> topSellingProducts = getTopSellingProducts(10);
        List<FinanceResponse.TopProduct> topValueProducts = getTopValueProducts(10);

        // Create response
        FinanceResponse response = new FinanceResponse();
        response.setOrderCount(orders.size()); // Set order count
        response.setTotalSales(totalSales);
        response.setTopSellingProducts(topSellingProducts);
        response.setTopValueProducts(topValueProducts);

        return response;
    }

    @Override
    public List<FinanceResponse.TopProduct> getTopSellingProducts(int limit) {
        List<OrderDetail> details = orderDetailRepository.findAll();
        Map<Long, FinanceResponse.TopProduct> productMap = new HashMap<>();
        for (OrderDetail detail : details) {
            Long productId = detail.getProduct().getId();
            FinanceResponse.TopProduct top = productMap.getOrDefault(productId, new FinanceResponse.TopProduct());
            top.setProductId(productId);
            top.setProductName(detail.getProduct().getName());
            top.setQuantitySold(top.getQuantitySold() + (detail.getQuantity() != null ? detail.getQuantity() : 0));
            top.setTotalValue(top.getTotalValue() == null ? BigDecimal.ZERO : top.getTotalValue());
            BigDecimal unitPrice = detail.getUnitPrice() != null ? BigDecimal.valueOf(detail.getUnitPrice()) : BigDecimal.ZERO;
            int quantity = detail.getQuantity() != null ? detail.getQuantity() : 0;
            BigDecimal value = unitPrice.multiply(BigDecimal.valueOf(quantity));
            top.setTotalValue(top.getTotalValue().add(value));
            productMap.put(productId, top);
        }
        return productMap.values().stream()
                .sorted(Comparator.comparingInt(FinanceResponse.TopProduct::getQuantitySold).reversed())
                .limit(limit)
                .collect(Collectors.toList());
    }

    @Override
    public List<FinanceResponse.TopProduct> getTopValueProducts(int limit) {
        List<OrderDetail> details = orderDetailRepository.findAll();
        Map<Long, FinanceResponse.TopProduct> productMap = new HashMap<>();
        for (OrderDetail detail : details) {
            Long productId = detail.getProduct().getId();
            FinanceResponse.TopProduct top = productMap.getOrDefault(productId, new FinanceResponse.TopProduct());
            top.setProductId(productId);
            top.setProductName(detail.getProduct().getName());
            top.setTotalValue(top.getTotalValue() == null ? BigDecimal.ZERO : top.getTotalValue());
            BigDecimal unitPrice = detail.getUnitPrice() != null ? BigDecimal.valueOf(detail.getUnitPrice()) : BigDecimal.ZERO;
            int quantity = detail.getQuantity() != null ? detail.getQuantity() : 0;
            BigDecimal value = unitPrice.multiply(BigDecimal.valueOf(quantity));
            top.setTotalValue(top.getTotalValue().add(value));
            top.setQuantitySold(top.getQuantitySold() + quantity);
            productMap.put(productId, top);
        }
        return productMap.values().stream()
                .sorted(Comparator.comparing(FinanceResponse.TopProduct::getTotalValue).reversed())
                .limit(limit)
                .collect(Collectors.toList());
    }
}