//
//  SwiftUIDemoView.swift
//  kPro
//
//  SwiftUI 学习 Demo - 涵盖 SwiftUI 核心概念
//

import SwiftUI

// MARK: - 主入口：Demo 列表
struct SwiftUIDemoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let demos: [DemoItem] = [
        DemoItem(title: "基础控件", subtitle: "Text, Image, Button, Toggle...", icon: "rectangle.3.group.fill", color: .blue),
        DemoItem(title: "布局系统", subtitle: "VStack, HStack, ZStack, Grid", icon: "square.grid.3x3.fill", color: .orange),
        DemoItem(title: "状态管理", subtitle: "@State, @Binding, @ObservedObject", icon: "arrow.triangle.2.circlepath", color: .purple),
        DemoItem(title: "列表与导航", subtitle: "List, NavigationLink, ForEach", icon: "list.bullet.rectangle.fill", color: .green),
        DemoItem(title: "表单与输入", subtitle: "Form, TextField, Picker, Slider", icon: "doc.text.fill", color: .red),
        DemoItem(title: "动画效果", subtitle: "Animation, Transition, withAnimation", icon: "sparkles", color: .pink),
        DemoItem(title: "自定义组件", subtitle: "卡片、进度环、自定义 Modifier", icon: "paintbrush.fill", color: .teal),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    // 头部欢迎卡片
                    WelcomeCard()
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Demo 列表
                    ForEach(demos) { demo in
                        NavigationLink(destination: destinationView(for: demo.title)) {
                            DemoRowView(item: demo)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength:30)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("SwiftUI Demo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "基础控件":
            BasicControlsDemo()
        case "布局系统":
            LayoutDemo()
        case "状态管理":
            StateManagementDemo()
        case "列表与导航":
            ListNavigationDemo()
        case "表单与输入":
            FormInputDemo()
        case "动画效果":
            AnimationDemo()
        case "自定义组件":
            CustomComponentsDemo()
        default:
            Text("Coming Soon")
        }
    }
}

// MARK: - 数据模型
struct DemoItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

// MARK: - 欢迎卡片
struct WelcomeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "swift")
                    .font(.system(size: 36))
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text("欢迎学习 SwiftUI")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("声明式 UI 框架")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            Text("SwiftUI 是 Apple 推出的现代化 UI 框架，使用声明式语法来构建用户界面。点击下方各个模块开始学习！")
                .font(.callout)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

// MARK: - Demo 行视图
struct DemoRowView: View {
    let item: DemoItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(item.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

// MARK: - =========================================
// MARK:   1. 基础控件 Demo
// MARK: - =========================================
struct BasicControlsDemo: View {
    @State private var isToggled = false
    @State private var sliderValue: Double = 50
    @State private var stepperValue = 3
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // --- Text ---
                SectionHeader(title: "Text 文本", code: "Text(\"Hello\").font(.title)")
                VStack(spacing: 8) {
                    Text("普通文本")
                    Text("粗体标题").font(.title).fontWeight(.bold)
                    Text("彩色文字").foregroundColor(.blue).italic()
                    Text("带下划线").underline(true, color: .red)
                    Text("自定义字体").font(.system(size: 20, weight: .medium, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- Image ---
                SectionHeader(title: "Image 图片", code: "Image(systemName: \"star.fill\")")
                HStack(spacing: 20) {
                    Image(systemName: "star.fill")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                    Image(systemName: "heart.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Image(systemName: "cloud.sun.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.blue, .yellow)
                    Image(systemName: "person.crop.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- Button ---
                SectionHeader(title: "Button 按钮", code: "Button(\"点击\") { action() }")
                VStack(spacing: 12) {
                    Button("默认按钮") { showAlert = true }
                        .buttonStyle(.bordered)
                    
                    Button("主要按钮") { showAlert = true }
                        .buttonStyle(.borderedProminent)
                    
                    Button(role: .destructive) { showAlert = true } label: {
                        Label("删除", systemImage: "trash")
                    }
                    .buttonStyle(.bordered)
                    
                    Button {
                        showAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("自定义按钮")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- Toggle ---
                SectionHeader(title: "Toggle 开关", code: "@State var isOn = false\nToggle(isOn: $isOn)")
                VStack {
                    Toggle("开启通知", isOn: $isToggled)
                    Text("状态: \(isToggled ? "开启" : "关闭")")
                        .foregroundColor(isToggled ? .green : .secondary)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- Slider ---
                SectionHeader(title: "Slider 滑块", code: "Slider(value: $val, in: 0...100)")
                VStack {
                    Slider(value: $sliderValue, in: 0...100)
                    Text("当前值: \(Int(sliderValue))")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- Stepper ---
                SectionHeader(title: "Stepper 步进器", code: "Stepper(value: $val, in: 0...10)")
                VStack {
                    Stepper("数量: \(stepperValue)", value: $stepperValue, in: 0...10)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
            }
            .padding()
        }
        .navigationTitle("基础控件")
        .navigationBarTitleDisplayMode(.inline)
        .alert("提示", isPresented: $showAlert) {
            Button("好的", role: .cancel) {}
        } message: {
            Text("你点击了按钮！这是 SwiftUI 的 Alert。")
        }
    }
}

// MARK: - =========================================
// MARK:   2. 布局系统 Demo
// MARK: - =========================================
struct LayoutDemo: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // --- VStack ---
                SectionHeader(title: "VStack 垂直布局", code: "VStack { ... }")
                VStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { i in
                        Text("第 \(i) 行")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(Double(i) * 0.2))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- HStack ---
                SectionHeader(title: "HStack 水平布局", code: "HStack { ... }")
                HStack(spacing: 8) {
                    ForEach(1...4, id: \.self) { i in
                        Text("\(i)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(Double(i) * 0.15))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- ZStack ---
                SectionHeader(title: "ZStack 层叠布局", code: "ZStack { ... }")
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.purple.opacity(0.3))
                        .frame(width: 200, height: 120)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple.opacity(0.5))
                        .frame(width: 160, height: 90)
                    Text("层叠在一起")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- Spacer & Padding ---
                SectionHeader(title: "Spacer & Alignment", code: "HStack { Text(\"左\"); Spacer(); Text(\"右\") }")
                VStack(spacing: 8) {
                    HStack {
                        Text("左对齐").foregroundColor(.blue)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("居中").foregroundColor(.purple)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("右对齐").foregroundColor(.red)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- LazyVGrid ---
                SectionHeader(title: "LazyVGrid 网格", code: "LazyVGrid(columns: [...]) { ... }")
                let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(1...9, id: \.self) { i in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hue: Double(i) / 10.0, saturation: 0.6, brightness: 0.9))
                                .aspectRatio(1, contentMode: .fit)
                            Text("\(i)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
            }
            .padding()
        }
        .navigationTitle("布局系统")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - =========================================
// MARK:   3. 状态管理 Demo
// MARK: - =========================================

// ObservableObject 示例
class CounterViewModel: ObservableObject {
    @Published var count = 0
    @Published var history: [String] = []
    
    func increment() {
        count += 1
        history.append("增加到 \(count)")
    }
    
    func decrement() {
        count -= 1
        history.append("减少到 \(count)")
    }
    
    func reset() {
        count = 0
        history.append("重置为 0")
    }
}

struct StateManagementDemo: View {
    // @State: 视图私有状态
    @State private var tapCount = 0
    @State private var name = ""
    @State private var color = Color.blue
    
    // @StateObject: 持有 ObservableObject
    @StateObject private var viewModel = CounterViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // --- @State ---
                SectionHeader(title: "@State", code: "@State private var count = 0")
                VStack(spacing: 12) {
                    Text("@State 用于视图的私有状态，值改变时视图自动刷新")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("点击次数: \(tapCount)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button("点击 +1") {
                        tapCount += 1
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- @Binding ---
                SectionHeader(title: "@Binding", code: "@Binding var value: String")
                VStack(spacing: 12) {
                    Text("@Binding 让子视图可以读写父视图的状态")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("输入你的名字", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    // 子视图通过 @Binding 接收
                    GreetingView(name: $name)
                    
                    ColorPickerChild(selectedColor: $color)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                        .frame(height: 50)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- @ObservedObject / @StateObject ---
                SectionHeader(title: "@StateObject + @ObservedObject", code: "@StateObject var vm = ViewModel()")
                VStack(spacing: 12) {
                    Text("@StateObject 持有并观察 ObservableObject，@Published 属性变更自动刷新 UI")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(viewModel.count)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(viewModel.count >= 0 ? .blue : .red)
                    
                    HStack(spacing: 20) {
                        Button { viewModel.decrement() } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                        }
                        
                        Button { viewModel.reset() } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        
                        Button { viewModel.increment() } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                    }
                    
                    if !viewModel.history.isEmpty {
                        Divider()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("操作历史:").font(.caption).foregroundColor(.secondary)
                            ForEach(viewModel.history.suffix(5), id: \.self) { item in
                                Text("• \(item)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
            }
            .padding()
        }
        .navigationTitle("状态管理")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 子组件：使用 @Binding
struct GreetingView: View {
    @Binding var name: String
    
    var body: some View {
        Text(name.isEmpty ? "请输入名字 👆" : "你好, \(name)! 🎉")
            .font(.headline)
            .foregroundColor(name.isEmpty ? .secondary : .primary)
    }
}

struct ColorPickerChild: View {
    @Binding var selectedColor: Color
    
    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .pink]
    
    var body: some View {
        HStack {
            Text("选择颜色:")
                .font(.subheadline)
            ForEach(colors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                    )
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

// MARK: - =========================================
// MARK:   4. 列表与导航 Demo
// MARK: - =========================================

struct Fruit: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
    let description: String
}

struct ListNavigationDemo: View {
    @State private var fruits = [
        Fruit(name: "苹果", emoji: "🍎", color: .red, description: "苹果富含维生素C和膳食纤维，是最受欢迎的水果之一。"),
        Fruit(name: "香蕉", emoji: "🍌", color: .yellow, description: "香蕉含有丰富的钾元素，是运动后的绝佳补给。"),
        Fruit(name: "葡萄", emoji: "🍇", color: .purple, description: "葡萄含有大量抗氧化物质，可以制成美味的葡萄酒。"),
        Fruit(name: "橙子", emoji: "🍊", color: .orange, description: "橙子富含维生素C，酸甜可口。"),
        Fruit(name: "西瓜", emoji: "🍉", color: .green, description: "西瓜含水量高，是夏季消暑的首选水果。"),
        Fruit(name: "草莓", emoji: "🍓", color: .pink, description: "草莓外形可爱，味道酸甜，营养丰富。"),
        Fruit(name: "桃子", emoji: "🍑", color: .orange, description: "桃子汁多味甜，自古就有「仙桃」之称。"),
    ]
    
    @State private var searchText = ""
    
    var filteredFruits: [Fruit] {
        if searchText.isEmpty {
            return fruits
        }
        return fruits.filter { $0.name.contains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 代码说明
            VStack(alignment: .leading) {
                Text("List + NavigationLink + .searchable + .onDelete")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
            
            List {
                ForEach(filteredFruits) { fruit in
                    NavigationLink(destination: FruitDetailView(fruit: fruit)) {
                        HStack(spacing: 12) {
                            Text(fruit.emoji)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(fruit.name)
                                    .font(.headline)
                                Text(fruit.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteFruit)
            }
            .searchable(text: $searchText, prompt: "搜索水果")
        }
        .navigationTitle("列表与导航")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
    }
    
    func deleteFruit(at offsets: IndexSet) {
        fruits.remove(atOffsets: offsets)
    }
}

struct FruitDetailView: View {
    let fruit: Fruit
    
    var body: some View {
        VStack(spacing: 24) {
            Text(fruit.emoji)
                .font(.system(size: 100))
            
            Text(fruit.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(fruit.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(fruit.color.opacity(0.3))
                .frame(height: 8)
                .padding(.horizontal, 80)
            
            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle(fruit.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - =========================================
// MARK:   5. 表单与输入 Demo
// MARK: - =========================================
struct FormInputDemo: View {
    @State private var username = ""
    @State private var email = ""
    @State private var age: Double = 25
    @State private var selectedGender = 0
    @State private var birthday = Date()
    @State private var agreeTerms = false
    @State private var notificationType = 1
    @State private var bio = ""
    @State private var showResult = false
    
    let genders = ["男", "女", "其他"]
    
    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                TextField("用户名", text: $username)
                TextField("邮箱", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                Picker("性别", selection: $selectedGender) {
                    ForEach(0..<genders.count, id: \.self) { index in
                        Text(genders[index]).tag(index)
                    }
                }
                
                DatePicker("生日", selection: $birthday, displayedComponents: .date)
            }
            
            Section(header: Text("年龄: \(Int(age))")) {
                Slider(value: $age, in: 1...100, step: 1)
            }
            
            Section(header: Text("通知偏好")) {
                Picker("通知方式", selection: $notificationType) {
                    Text("邮件").tag(0)
                    Text("推送").tag(1)
                    Text("短信").tag(2)
                }
                .pickerStyle(.segmented)
            }
            
            Section(header: Text("个人简介")) {
                TextEditor(text: $bio)
                    .frame(minHeight: 80)
            }
            
            Section {
                Toggle("同意服务条款", isOn: $agreeTerms)
            }
            
            Section {
                Button {
                    showResult = true
                } label: {
                    HStack {
                        Spacer()
                        Text("提交")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(!agreeTerms || username.isEmpty)
            }
        }
        .navigationTitle("表单与输入")
        .navigationBarTitleDisplayMode(.inline)
        .alert("提交成功", isPresented: $showResult) {
            Button("好的") {}
        } message: {
            Text("用户名: \(username)\n邮箱: \(email)\n性别: \(genders[selectedGender])\n年龄: \(Int(age))")
        }
    }
}

// MARK: - =========================================
// MARK:   6. 动画效果 Demo
// MARK: - =========================================
struct AnimationDemo: View {
    @State private var isScaled = false
    @State private var rotation: Double = 0
    @State private var offset: CGFloat = 0
    @State private var showCard = false
    @State private var isLoading = false
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // --- 缩放动画 ---
                SectionHeader(title: "缩放动画", code: ".scaleEffect()\n.animation(.spring())")
                VStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                        .scaleEffect(isScaled ? 1.5 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.3), value: isScaled)
                    
                    Button("点击缩放") {
                        isScaled.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- 旋转动画 ---
                SectionHeader(title: "旋转动画", code: ".rotationEffect(.degrees(angle))")
                VStack {
                    Image(systemName: "gear")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(rotation))
                    
                    Button("旋转 90°") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            rotation += 90
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- 位移动画 ---
                SectionHeader(title: "位移动画", code: ".offset(x: value)\nwithAnimation { }")
                VStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .offset(x: offset)
                    
                    HStack {
                        Button("← 左") {
                            withAnimation(.easeInOut) { offset -= 50 }
                        }
                        Button("重置") {
                            withAnimation(.spring()) { offset = 0 }
                        }
                        Button("右 →") {
                            withAnimation(.easeInOut) { offset += 50 }
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- 转场动画 ---
                SectionHeader(title: "转场动画", code: ".transition(.scale.combined(with: .opacity))")
                VStack {
                    if showCard {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(height: 100)
                            .overlay(
                                Text("卡片出现了！")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            )
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Button(showCard ? "隐藏卡片" : "显示卡片") {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showCard.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- 加载动画 ---
                SectionHeader(title: "加载动画", code: ".repeatForever()\n.rotationEffect()")
                VStack(spacing: 16) {
                    if isLoading {
                        HStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("加载中...")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(isLoading ? "停止" : "开始加载") {
                        withAnimation { isLoading.toggle() }
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
            }
            .padding()
        }
        .navigationTitle("动画效果")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - =========================================
// MARK:   7. 自定义组件 Demo
// MARK: - =========================================
struct CustomComponentsDemo: View {
    @State private var progress1: CGFloat = 0.7
    @State private var progress2: CGFloat = 0.45
    @State private var progress3: CGFloat = 0.9
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // --- 自定义卡片 ---
                SectionHeader(title: "自定义卡片组件", code: "struct CardView: View { ... }")
                
                CardView(
                    title: "SwiftUI",
                    subtitle: "声明式 UI 框架",
                    icon: "swift",
                    gradient: [.orange, .red]
                )
                
                CardView(
                    title: "Combine",
                    subtitle: "响应式编程框架",
                    icon: "arrow.triangle.merge",
                    gradient: [.blue, .purple]
                )
                
                // --- 进度环 ---
                SectionHeader(title: "自定义进度环", code: "Circle().trim(from: 0, to: progress)")
                HStack(spacing: 30) {
                    ProgressRing(progress: progress1, color: .blue, label: "Swift")
                    ProgressRing(progress: progress2, color: .green, label: "UI")
                    ProgressRing(progress: progress3, color: .orange, label: "效率")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- 自定义 ViewModifier ---
                SectionHeader(title: "自定义 Modifier", code: "extension View {\n  func cardStyle() -> some View\n}")
                
                VStack(spacing: 12) {
                    Text("使用 .cardStyle()")
                        .font(.headline)
                        .modifier(CardModifier())
                    
                    Text("使用 .tagStyle()")
                        .modifier(TagModifier(color: .blue))
                    
                    HStack {
                        Text("标签1").modifier(TagModifier(color: .red))
                        Text("标签2").modifier(TagModifier(color: .green))
                        Text("标签3").modifier(TagModifier(color: .purple))
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemGroupedBackground)))
                
                // --- 组合示例: 个人资料卡 ---
                SectionHeader(title: "组合示例: 个人资料", code: "综合运用以上所有知识")
                ProfileCard()
            }
            .padding()
        }
        .navigationTitle("自定义组件")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 自定义卡片
struct CardView: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "arrow.right.circle.fill")
                .font(.title2)
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

// 自定义进度环
struct ProgressRing: View {
    let progress: CGFloat
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                    .frame(width: 70, height: 70)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 70, height: 70)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// 自定义 ViewModifier
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemGroupedBackground))
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
            )
    }
}

struct TagModifier: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(color.opacity(0.15))
            )
    }
}

// 组合示例：个人资料卡
struct ProfileCard: View {
    @State private var isFollowing = false
    
    var body: some View {
        VStack(spacing: 16) {
            // 头像
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 80, height: 80)
                
                Text("K")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            // 名称
            VStack(spacing: 4) {
                Text("SwiftUI 开发者")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("@swiftui_learner")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // 统计
            HStack(spacing: 30) {
                StatItem(value: "42", label: "项目")
                StatItem(value: "1.2k", label: "关注")
                StatItem(value: "890", label: "粉丝")
            }
            
            // 按钮
            Button {
                withAnimation(.spring()) {
                    isFollowing.toggle()
                }
            } label: {
                Text(isFollowing ? "已关注 ✓" : "关注")
                    .fontWeight(.semibold)
                    .foregroundColor(isFollowing ? .secondary : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isFollowing ? Color(.systemGray5) : Color.blue)
                    )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - 通用组件：Section Header
struct SectionHeader: View {
    let title: String
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            
            Text(code)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.secondary)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
        }
    }
}

// MARK: - Preview
struct SwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIDemoView()
    }
}
