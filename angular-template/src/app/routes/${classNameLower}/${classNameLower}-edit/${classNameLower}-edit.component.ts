import {Component, OnDestroy, OnInit} from "@angular/core";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";
import {ActivatedRoute} from "@angular/router";
import {Location} from "@angular/common";
import {${className}Service} from "../${classNameLower}.service";

@Component({
  selector: 'app-${classNameLower}-edit',
  templateUrl: './${classNameLower}-edit.component.html',
  styleUrls: ['./${classNameLower}-edit.component.css']
})
export class ${className}EditComponent implements OnInit {
  public isConfirmLoading: boolean = false;
  private code: string; //供应商编码，修改时会传过来
  public validateForm: FormGroup;//企业登录的表单

  constructor(private fb: FormBuilder, private ${classNameLower}Service: ${className}Service, private route: ActivatedRoute, public location: Location) {
    this.validateForm = this.fb.group({
    <#list fields as field>
    <#if field.field!='id' && field.field!='code' && field.field!='state' && !field.checkDate>
      ${field.field}: [null, Validators.compose([Validators.required])]<#if field_has_next>,</#if> // ${field.notes}
    </#if>
    </#list>
    });
  }

  ngOnInit() {
    this.route.url.subscribe(url => {
      const curPath = url[0].path;
      if (curPath === 'modify') {
        this.code = this.route.snapshot.params.code;//获取参数
        this.load${className}Info();
      }//修改前查询出供应商信息
    })
  }

  /**
   * 表单确认
   */
  add${className}($event) {
    $event.preventDefault();
    //1.进行脏检查，提示未填的必填字段
    for (const key in this.validateForm.controls) {
      this.validateForm.controls[key].markAsDirty();
      this.validateForm.controls[key].updateValueAndValidity();
    }
    if (this.validateForm.invalid) return;
    this.isConfirmLoading = true;
    let formData = Object.assign({},this.validateForm.value);
    //添加${classNameLower}
    if (this.code) {
      formData.code = this.code;
      this.${classNameLower}Service.modify${className}(formData).then((data: any) => {
        this.isConfirmLoading = false;
        this.validateForm.reset();
        this.location.back();
      }).catch(res => this.isConfirmLoading = false)
    } else {
      this.${classNameLower}Service.add${className}(formData).then((data: any) => {
        this.isConfirmLoading = false;
        this.location.back();
      }).catch(res => this.isConfirmLoading = false)
    }
  }

  /**
   * 查询供应商信息
   */
  load${className}Info() {
    this.${classNameLower}Service.load${className}ByCode(this.code).then((data: any) => {
      this.validateForm.patchValue(data);
    })
  }


  getFormControl(name) {
    return this.validateForm.controls[name];
  }
}