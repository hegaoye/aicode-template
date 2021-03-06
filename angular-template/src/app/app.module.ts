import {NgModule} from "@angular/core";

import {AppComponent} from "./app.component";
import {HttpClient, HttpClientModule} from "@angular/common/http";
import {SharedModule} from "./shared/shared.module";
import {RoutesModule} from "./routes/routes.module";
import {PublicModule} from "./public/public.module";
import {MainComponent} from "./layout/main/main.component";
import {BrowserModule} from "@angular/platform-browser";
import {BrowserAnimationsModule} from "@angular/platform-browser/animations";
import {FormsModule} from "@angular/forms";
import {PageComponent} from "./layout/page/page.component";
import {NgxEchartsModule} from "ngx-echarts";
import { registerLocaleData } from '@angular/common';
import zh from '@angular/common/locales/zh';
registerLocaleData(zh);

@NgModule({
  declarations: [
    AppComponent,
    MainComponent,
    PageComponent
  ],
  imports: [
    RoutesModule,
    SharedModule.forRoot(),
    PublicModule,
    FormsModule,
    NgxEchartsModule,
    BrowserModule,                //浏览器模块
    BrowserAnimationsModule,    //浏览器动画模块
    HttpClientModule,             //网络请求模块
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
