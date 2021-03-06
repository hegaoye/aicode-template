/*
 * Copyright (c) 2019. 郑州仁中和科技有限公司.保留所有权利. 
http://www.rzhkj.com/ 
郑州仁中和科技有限公司保留所有代码著作权.如有任何疑问请访问官方网站与我们联系. 代码只针对特定客户使用，不得在未经允许或授权的情况下对外传播扩散.恶意传播者，法律后果自行承担.
 */
package com.ponddy.core.tools;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;


/**
 * 分页排序工具类
 * Created by lixin on 2017/6/5.
 */
public class SortTools implements Serializable {
    private static final long serialVersionUID = 8138022018100161833L;
    private Direction direction;
    private String property;
    private String orderExpr;

    public SortTools(String property, Direction direction, String orderExpr) {
        this.direction = direction;
        this.property = property;
        this.orderExpr = orderExpr;
    }

    public Direction getDirection() {
        return direction;
    }

    public String getProperty() {
        return property;
    }

    public String getOrderExpr() {
        return orderExpr;
    }

    public void setDirection(Direction direction) {
        this.direction = direction;
    }

    public void setProperty(String property) {
        this.property = property;
    }

    public void setOrderExpr(String orderExpr) {
        this.orderExpr = orderExpr;
    }

    private static String INJECTION_REGEX = "[A-Za-z0-9\\_\\-\\+\\.]+";

    public static boolean isSQLInjection(String str) {
        return !Pattern.matches(INJECTION_REGEX, str);
    }

    @Override
    public String toString() {
        if (isSQLInjection(property)) {
            throw new IllegalArgumentException("SQLInjection property: " + property);
        }
        if (orderExpr != null && orderExpr.indexOf("?") != -1) {
            String[] exprs = orderExpr.split("\\?");
            if (exprs.length == 2) {
                return String.format(orderExpr.replaceAll("\\?", "%s"), property) + (direction == null ? "" : " " + direction.name());
            }
            return String.format(orderExpr.replaceAll("\\?", "%s"), property, direction == null ? "" : " " + direction.name());
        }
        return property + (direction == null ? "" : " " + direction.name());
    }


    public static List<SortTools> formString(String orderSegment) {
        return formString(orderSegment, null);
    }

    /**
     * @param orderSegment ex: "id.asc,code.desc" or "code.desc"
     */
    public static List<SortTools> formString(String orderSegment, String orderExpr) {
        if (orderSegment == null || orderSegment.trim().equals("")) {
            return new ArrayList(0);
        }

        List<SortTools> results = new ArrayList();
        String[] orderSegments = orderSegment.trim().split(",");
        for (int i = 0; i < orderSegments.length; i++) {
            String sortSegment = orderSegments[i];
            SortTools order = _formString(sortSegment, orderExpr);
            if (order != null) {
                results.add(order);
            }
        }
        return results;
    }

    private static SortTools _formString(String orderSegment, String orderExpr) {
        SortTools sortTools=null;
        if (orderSegment == null || orderSegment.trim().equals("") ||
                orderSegment.startsWith("null.") || orderSegment.startsWith(".")) {
            return null;
        }

        String[] array = orderSegment.trim().split("\\.");
        if (array.length != 1 && array.length != 2 && array.length != 3) {
            throw new IllegalArgumentException("orderSegment pattern must be {property}.{direction}, input is: " + orderSegment);
        }
        if(array.length==3){
            sortTools=create(array[0]+"."+array[1], array[2], orderExpr);
        }else{
            sortTools=create(array[0], array.length == 2 ? array[1] : "asc", orderExpr);
        }

        return sortTools;
    }

    public static SortTools create(String property, String direction) {
        return create(property, direction, null);
    }

    /**
     * @param property
     * @param direction
     * @param orderExpr placeholder is "?", in oracle like: "nlssort( ? ,'NLS_SORT=SCHINESE_PINYIN_M')".
     *                  Warning: you must prevent orderExpr SQL injection.
     * @return
     */
    public static SortTools create(String property, String direction, String orderExpr) {
        return new SortTools(property, SortTools.Direction.fromString(direction), orderExpr);
    }


    /**
     * PropertyPath implements the pairing of an {@link Direction} and a property. It is used to provide input for
     *
     * @author Oliver Gierke
     */
    public static enum Direction {
        ASC, DESC;

        public static Direction fromString(String value) {
            try {
                return Direction.valueOf(value.toUpperCase(Locale.US));
            } catch (Exception e) {
                return ASC;
            }
        }
    }
}
