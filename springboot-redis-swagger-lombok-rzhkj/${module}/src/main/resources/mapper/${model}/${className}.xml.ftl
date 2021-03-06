<#macro mapperEl value>${r"#{"}${value}}</#macro>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="${basePackage}.${model}.dao.${className}DAO">

    <resultMap id="rs_base" type="${className}">
    <#list fields as field>
        <result property="${field.field}" column="${field.column}"/>
    </#list>
    </resultMap>

    <sql id="columns">
    <#list columns as column>${column.column}<#if column_has_next>,</#if></#list>
    </sql>

    <sql id="where">
        <where>
        <#list fields as field>
            <#if field.checkDate>
                <if test="${field.field}Begin!=null">
                    AND ${field.column} >= <@mapperEl field.field+"Begin"/>
                </if>
                <if test="${field.field}End!=null">
                    AND ${field.column} &lt;= <@mapperEl field.field+"End"/>
                </if>
            <#elseif field.checkState>
                <if test="${field.field}s!=null and ${field.field}s!=''">
                    AND ${field.column} in
                    <foreach collection="${field.field}s" index="index" item="stateIn" open="(" separator="," close=")">
                        <@mapperEl stateIn/>
                    </foreach>
                </if>
            <#else>
                <if test="${field.field}!=null and ${field.field}!=''">
                    AND ${field.column} = <@mapperEl field.field/>
                </if>
            </#if>
        </#list>
        </where>
    </sql>

    <!--向${tableName}插入一条数据-->
    <insert id="insert" useGeneratedKeys="true" keyProperty="id" parameterType="${className}">
        INSERT INTO `${tableName}` (
    <#list columns as column>
    ${column.column} <#if column_has_next>,</#if>
    </#list>
        ) VALUES (
    <#list fields as field>
        <@mapperEl field.field/> <#if field_has_next>,</#if>
    </#list>
        )
        <selectKey keyProperty="id" resultType="long">
            select LAST_INSERT_ID()
        </selectKey>
    </insert>

    <!--向${tableName}批量插入数据-->
    <insert id="batchInsert" useGeneratedKeys="true" keyProperty="id" parameterType="${className}">
        INSERT INTO `${tableName}` (
    <#list columns as column>
    ${column.column} <#if column_has_next>,</#if>
    </#list>
        ) VALUES
        <foreach item='item' index='index' collection='list' separator=','>
            (
        <#list fields as field>
        ${r'#{item.'}${field.field}${r'}'}<#if field_has_next>,</#if>
        </#list>
            )
        </foreach>

        <selectKey keyProperty="id" resultType="long">
            select LAST_INSERT_ID()
        </selectKey>
    </insert>

    <!--根据主键更新 ${tableName} 的数据-->
    <update id="update" parameterType="${className}">
        UPDATE `${tableName}`
        <trim prefix="set" suffixOverrides=",">
        <#if (notPkFields?size>0)>
            <#list notPkFields as field>
                <#if field.checkDate>
                    <if test="${field.field}!=null">
                    ${field.column} = <@mapperEl field.field/> <#if field_has_next>,</#if>
                    </if>
                <#else>
                    <if test="${field.field}!=null and ${field.field}!=''">
                    ${field.column} = <@mapperEl field.field/> <#if field_has_next>,</#if>
                    </if>
                </#if>
            </#list>
        </#if>
        </trim>
        <where>
        <#list fields as field>
            <#if field.checkDate>
                <if test="${field.field}Begin!=null">
                    AND ${field.column} >= <@mapperEl field.field+"Begin"/>
                </if>
                <if test="${field.field}End!=null">
                    AND ${field.column} &lt;= <@mapperEl field.field+"End"/>
                </if>
            <#elseif field.checkState>
                <if test="${field.field}s!=null and ${field.field}s!=''">
                    AND ${field.column} in
                    <foreach collection="${field.field}s" index="index" item="stateIn" open="(" separator="," close=")">
                        <@mapperEl stateIn/>
                    </foreach>
                </if>
            <#elseif field.checkPk>
                <if test="${field.field}!=null">
                    AND ${field.column} = <@mapperEl field.field/>
                </if>
            </#if>
        </#list>
        </where>
    </update>

<#if (pkFields?size>0)>
    <#list pkFields as pkField>
        <!--根据主键更新 ${tableName} 的数据-->
        <update id="updateStateBy${pkField.field?cap_first}" parameterType="map">
            UPDATE `${tableName}`
            <trim prefix="set" suffixOverrides=",">
                <if test="newState!=null and newState!=''">
                    state = ${r'#{newState}'}
                </if>
                <if test="updateTime!=null">
                    updateTime = ${r'#{updateTime}'}
                </if>
            </trim>
            <where>
                <if test="${pkField.field}!=null">
                   ${pkField.column} = <@mapperEl pkField.field/>
                </if>
                <if test="oldStates!=null">
                    AND state in
                    <foreach collection="oldStates" index="index" item="stateIn" open="(" separator="," close=")">
                    ${r'#{stateIn}'}
                    </foreach>
                </if>
            </where>
        </update>
    </#list>

    <#list pkFields as pkField>
        <!--根据主键更新 ${tableName} 的状态数据-->
        <update id="updateBy${pkField.field?cap_first}" parameterType="map">
            UPDATE `${tableName}`
            <trim prefix="set" suffixOverrides=",">
                <if test="state!=null and state!=''">
                    state = ${r'#{state}'}
                </if>
                <if test="updateTime!=null">
                    updateTime = ${r'#{updateTime}'}
                </if>
            </trim>
            where ${pkField.column}=<@mapperEl pkField.field/>
        </update>
    </#list>


</#if>

    <!--根据任意条件删除${tableName}信息-->
    <delete id="delete">
        DELETE FROM `${tableName}`
        <include refid="where"/>
    </delete>

    <!--根据任何条件加载一条${tableName}的数据-->
    <select id="load" resultMap="rs_base">
        SELECT
        <include refid="columns"/>
        FROM `${tableName}`
        <include refid="where"/>
    </select>

<#if (pkFields?size>0)>
    <#list pkFields as pkfield>
        <!--查询一条${tableName} loadBy${pkfield.field?cap_first}  通过${pkfield.field} -->
        <select id="loadBy${pkfield.field?cap_first}" resultMap="rs_base" parameterType="${pkfield.fieldType}">
            SELECT
            <include refid="columns"/>
            FROM `${tableName}`
            where ${pkfield.column} = <@mapperEl pkfield.field/>
        </select>
    </#list>


        <!--查询一条${tableName} countByPk -->
        <select id="listByPk" resultMap="rs_base">
            SELECT
            <include refid="columns"/>
            FROM `${tableName}`
            where
            <#list pkFields as pkfield>
            <if test="${pkfield.field}!=null">
            And ${pkfield.column} = <@mapperEl pkfield.field/>
            </if>
            </#list>
            <if test="state!=null">
                AND state =${r'#{state}'}
            </if>
        </select>

        <!--查询一条${tableName} countByPk-->
        <select id="countByPk" resultType="integer">
            SELECT count(1)
            FROM `${tableName}`
            where
            <#list pkFields as pkfield>
            <if test="${pkfield.field}!=null">
            And ${pkfield.column} = <@mapperEl pkfield.field/>
            </if>
            </#list>
            <if test="state!=null">
                AND state =${r'#{state}'}
            </if>
        </select>
</#if>


    <!--根据任何条件统计${tableName}数据条数-->
    <select id="count" resultType="integer">
        SELECT count(1) FROM `${tableName}`
        <include refid="where"/>
    </select>

    <!--根据任何条件分页查询${tableName}-->
    <select id="list" resultMap="rs_base">
        SELECT
        <include refid="columns"/>
        FROM `${tableName}`
        <include refid="where"/>

        <if test="sortColumns!=null and sortColumns!=''">
            ORDER BY ${r'${sortColumns}'}
        </if>
    </select>


</mapper>
